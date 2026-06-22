<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\BookingController;

// ─── AUTH ────────────────────────────────────────────────
Route::post('/register', [UserController::class, 'register']);
Route::post('/login',    [UserController::class, 'login']);

// ─── FLOOR & SLOT ────────────────────────────────────────
Route::get('/floor',           [BookingController::class, 'allFloors']);
Route::get('/floor/{floorId}', [BookingController::class, 'floorStatus']);

// ─── BOOKING ─────────────────────────────────────────────
Route::post('/booking',                        [BookingController::class, 'createBooking']);
Route::post('/booking/{id}/upload-dp',         [BookingController::class, 'uploadDp']);
Route::get('/booking/user/{userId}',           [BookingController::class, 'userBookings']);
Route::post('/checkin/{bookingCode}',          [BookingController::class, 'checkIn']);
Route::post('/booking/cancel/{id}', [BookingController::class, 'cancelBooking']);

// ─── CHECKOUT & PAYMENT (baru) ──────────────────────────
Route::post('/checkout-process/{bookingCode}', [BookingController::class, 'processCheckout']);
Route::post('/confirm-payment/{paymentId}',    [BookingController::class, 'confirmFinalPayment']);

// Route lama (optional, bisa dipertahankan)
Route::post('/checkout/{bookingCode}',         [BookingController::class, 'checkOut']);

