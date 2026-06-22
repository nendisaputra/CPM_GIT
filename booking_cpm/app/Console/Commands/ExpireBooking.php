<?php

namespace App\Console\Commands;
use App\Models\Booking;
use Illuminate\Console\Command;

class ExpireBooking extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:expire-booking';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

    /**
     * Execute the console command.
     */
    // app/Console/Commands/ExpireBooking.php
public function handle()
{
    $expired = Booking::whereIn('status', ['pending_dp', 'active'])
        ->where('created_at', '<=', now()->subMinutes(15))
        ->get();

    foreach ($expired as $booking) {
        $booking->slot->update(['status' => 'available']);
        $booking->update(['status' => 'cancelled']);
    }
}
}
