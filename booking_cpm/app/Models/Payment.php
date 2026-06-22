<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\Booking;

class Payment extends Model
{
    protected $table = 'payment';

    protected $fillable = [
        'booking_id',
        'amount',
        'proof',
        'status'
    ];

    public function booking()
    {
        return $this->belongsTo(Booking::class, 'booking_id');
    }
}