<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ParkingSlot extends Model
{
    protected $table = 'parking_slot';

    protected $fillable = [
        'floor_id',
        'kode_slot',
        'status'
    ];

    public function floor()
    {
        return $this->belongsTo(Floor::class);
    }

    public function bookings()
    {
        return $this->hasMany(Booking::class, 'slot_id');
    }
}