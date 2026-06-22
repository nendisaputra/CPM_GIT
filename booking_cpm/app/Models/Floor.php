<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Floor extends Model
{
    protected $table = 'floor';

    protected $fillable = [
        'name',
        'capacity',
        'occupied'
    ];

    public function slots()
    {
        return $this->hasMany(ParkingSlot::class, 'floor_id');
    }
}