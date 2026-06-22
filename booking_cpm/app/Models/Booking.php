<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\User;
use App\Models\ParkingSlot;
use App\Models\Payment;

class Booking extends Model
{
    protected $table = 'booking';

    protected $fillable = [
        'booking_code',
        'user_id',
        'slot_id',
        'booking_time',
        'expired_time',
        'check_in_time',
        'check_out_time',
        'total_payment',
        'status'
    ];

    // 🔥 TAMBAHKAN INI
    protected $casts = [
        'booking_time'   => 'datetime',
        'expired_time'   => 'datetime',
        'check_in_time'  => 'datetime',
        'check_out_time' => 'datetime',
        'created_at'     => 'datetime',
        'updated_at'     => 'datetime',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function slot()
    {
        return $this->belongsTo(ParkingSlot::class);
    }

    public function payment()
    {
        return $this->hasOne(Payment::class);
    }
}