<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Booking;
use App\Models\Floor;
use App\Models\Payment;
use App\Models\ParkingSlot;


class DashboardController extends Controller
{
    public function index()
    {
        return view('index',[
    'totalUser' => User::count(),
    'totalBooking' => Booking::count(),
    'checkedIn' => Booking::where(
        'status',
        'checked_in'
    )->count(),
    'income' => Booking::sum(
        'total_payment'
    ),
    'floors' => Floor::all(),
    'slots' => [],
    'bookings' => Booking::latest()
        ->take(10)
        ->get(),

    'payments' => Payment::latest()
        ->take(10)
        ->get()
    ]);
    }
}