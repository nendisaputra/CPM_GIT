<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Floor;
use App\Models\ParkingSlot;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        for ($i = 1; $i <= 5; $i++) {
            $zona = chr(64 + $i);
            $floor = Floor::create([
                'name' => "Lantai $i (Zona $zona)",
                'capacity' => 8,
                'occupied' => 0,
            ]);

            for ($j = 1; $j <= 8; $j++) {
                ParkingSlot::create([
                    'floor_id'  => $floor->id,
                    'kode_slot' => $zona . $j,
                    'status'    => 'available',
                ]);
            }
        }
    }
}