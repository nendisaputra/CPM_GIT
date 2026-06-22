<?php

namespace App\Http\Controllers;

use App\Models\Floor;
use App\Models\ParkingSlot;
use App\Models\Booking;
use App\Models\Payment;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;

class BookingController extends Controller
{
    // Semua lantai
    public function allFloors()
    {
        $floors = Floor::with(['slots' => function($q) {
            $q->select('id', 'floor_id', 'kode_slot', 'status');
        }])->get();

        return response()->json([
            'success' => true,
            'floors' => $floors
        ]);
    }

    // Slot per lantai
    public function floorStatus($floorId)
    {
        $slots = ParkingSlot::where('floor_id', $floorId)->get();
        return response()->json([
            'success' => true,
            'slots' => $slots
        ]);
    }

    // Membuat booking baru (status pending_dp)
    public function createBooking(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
            'slot_id' => 'required|exists:parking_slot,id',
            'total_payment' => 'required|integer|min:5000',
        ]);

        $slot = ParkingSlot::find($request->slot_id);
        if ($slot->status !== 'available') {
            return response()->json([
                'success' => false,
                'message' => 'Slot tidak tersedia'
            ], 400);
        }

        try {
            $bookingCode = 'BK-' . strtoupper(Str::random(13));
            $booking = Booking::create([
                'booking_code' => $bookingCode,
                'user_id' => $request->user_id,
                'slot_id' => $request->slot_id,
                'booking_time' => now(),
                'expired_time' => now()->addMinutes(30),
                'total_payment' => $request->total_payment,
                'status' => 'pending_dp'
            ]);

            // Ubah slot menjadi booked
            $slot->status = 'booked';
            $slot->save();

            Log::info('Booking created: '.$bookingCode.', Slot '.$slot->id.' -> booked');

            return response()->json([
                'success' => true,
                'message' => 'Booking berhasil, silakan upload DP',
                'booking' => $booking
            ]);
        } catch (\Exception $e) {
            Log::error('Gagal booking: '.$e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Gagal membuat booking: '.$e->getMessage()
            ], 500);
        }
    }

    // Upload bukti DP (ubah status jadi active)
    public function uploadDp(Request $request, $id)
    {
        $request->validate([
            'amount' => 'required|integer|min:5000',
            'proof' => 'required|image|mimes:jpeg,png,jpg|max:2048'
        ]);

        $booking = Booking::find($id);
        if (!$booking || $booking->status !== 'pending_dp') {
            return response()->json([
                'success' => false,
                'message' => 'Booking tidak valid atau sudah tidak pending'
            ], 400);
        }

        // Simpan file bukti
        $file = $request->file('proof');
        $path = $file->store('payments', 'public');

        Payment::create([
            'booking_id' => $booking->id,
            'amount' => $request->amount,
            'proof' => $path,
            'status' => 'approved'
        ]);

        // Ubah status booking menjadi active
        $booking->status = 'active';
        $booking->save();

        Log::info('DP uploaded for booking '.$booking->booking_code.', status -> active');

        return response()->json([
            'success' => true,
            'message' => 'DP berhasil diupload, booking aktif'
        ]);
    }

    // Semua booking milik user
    public function userBookings($userId)
    {
        $bookings = Booking::where('user_id', $userId)
            ->with(['slot.floor', 'payment'])
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'bookings' => $bookings
        ]);
    }

    // Check-in
    public function checkIn($bookingCode)
    {
        $booking = Booking::where('booking_code', $bookingCode)->first();
        if (!$booking) {
            return response()->json(['success' => false, 'message' => 'Booking tidak ditemukan'], 404);
        }

        // Hanya bisa check-in jika status 'active'
        if ($booking->status !== 'active') {
            return response()->json([
                'success' => false,
                'message' => 'Booking tidak bisa check-in. Status saat ini: '.$booking->status
            ], 400);
        }

        $booking->check_in_time = now();
        $booking->status = 'checked_in';
        $booking->save();

        // Ubah slot menjadi occupied
        $slot = $booking->slot;
        $slot->status = 'occupied';
        $slot->save();

        Log::info('Check-in success: '.$bookingCode.', Slot '.$slot->id.' -> occupied');

        return response()->json([
            'success' => true,
            'message' => 'Check-in berhasil',
            'booking' => $booking
        ]);
    }

    // Check-out dan hitung biaya (legacy, mungkin tidak dipakai)
    public function checkOut(Request $request, $bookingCode)
    {
        // Method ini mungkin tidak dipakai, lebih baik pakai processCheckout
        return $this->processCheckout($request, $bookingCode);
    }

    // Process checkout (hitung dan buat payment)
    public function processCheckout(Request $request, $bookingCode)
    {
        $booking = Booking::where('booking_code', $bookingCode)->first();
        if (!$booking) {
            return response()->json(['success' => false, 'message' => 'Booking tidak ditemukan'], 404);
        }

        // Hanya bisa checkout jika status 'checked_in'
        if ($booking->status !== 'checked_in') {
            return response()->json([
                'success' => false,
                'message' => 'Belum check-in. Status saat ini: '.$booking->status
            ], 400);
        }

        if (!$booking->check_in_time) {
            return response()->json(['success' => false, 'message' => 'Waktu check-in tidak valid'], 400);
        }

        $checkOutTime = now();
        $checkInTime = $booking->check_in_time;
        $minutes = $checkInTime->diffInMinutes($checkOutTime);
        $hours = ceil($minutes / 60);
        $tarif = 5000 + max(0, ($hours - 1) * 3000);

        $sisaBayar = $tarif - 5000;
        if ($sisaBayar < 0) $sisaBayar = 0;

        // Simpan waktu checkout dan total
        $booking->check_out_time = $checkOutTime;
        $booking->total_payment = $tarif;
        $booking->save();

        // Buat payment dengan status pending
        $payment = Payment::create([
            'booking_id' => $booking->id,
            'amount' => $sisaBayar,
            'proof' => 'pending_online',
            'status' => 'pending'
        ]);

        Log::info('Checkout processed for '.$bookingCode.', payment_id: '.$payment->id);

        return response()->json([
            'success' => true,
            'message' => 'Silakan melakukan pembayaran sisa',
            'total_payment' => $tarif,
            'sisa_bayar' => $sisaBayar,
            'payment_id' => $payment->id,
            'booking' => $booking
        ]);
    }

    // Konfirmasi pembayaran final (setelah user bayar)
    public function confirmFinalPayment($paymentId)
    {
        $payment = Payment::find($paymentId);
        if (!$payment || $payment->status !== 'pending') {
            return response()->json(['success' => false, 'message' => 'Payment tidak valid'], 400);
        }

        $payment->status = 'approved';
        $payment->save();

        $booking = $payment->booking;
        $booking->status = 'completed';
        $booking->save();

        // Kosongkan slot
        $slot = $booking->slot;
        if ($slot) {
            $slot->status = 'available';
            $slot->save();
            Log::info('Slot '.$slot->id.' diubah menjadi available setelah pembayaran');
        } else {
            Log::error('Slot tidak ditemukan untuk booking '.$booking->id);
        }

        return response()->json([
            'success' => true,
            'message' => 'Pembayaran berhasil, terima kasih. Portal terbuka.'
        ]);
    }

    // Cancel booking (expired)
    public function cancelBooking($id)
    {
        try {
            $booking = Booking::find($id);
           // Di checkIn, tambahkan pesan status
if ($booking->status !== 'active') {
        return response()->json([
            'success' => false,
            'message' => 'Booking tidak bisa check-in. Status saat ini: '.$booking->status
        ], 400);
    }

            // Hanya boleh dibatalkan jika status 'pending_dp' atau 'active'
            if (!in_array($booking->status, ['pending_dp', 'active'])) {
                return response()->json([
                    'success' => false,
                    'message' => 'Booking tidak dapat dibatalkan. Status saat ini: '.$booking->status
                ], 400);
            }

            // Kembalikan slot ke available
            $slot = ParkingSlot::find($booking->slot_id);
            if ($slot) {
                $slot->status = 'available';
                $slot->save();
                Log::info('Slot '.$slot->id.' dikembalikan ke available (cancel booking)');
            }

            // Ubah status booking menjadi 'cancelled'
            $booking->status = 'cancelled';
            $booking->save();

            return response()->json([
                'success' => true,
                'message' => 'Booking dibatalkan karena melewati batas waktu'
            ]);
        } catch (\Exception $e) {
            Log::error('Cancel booking error: '.$e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Terjadi error: ' . $e->getMessage()
            ], 500);
        }
    }
}