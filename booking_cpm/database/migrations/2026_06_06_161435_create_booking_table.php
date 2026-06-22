<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('booking', function (Blueprint $table) {
            $table->id();
            $table->string('booking_code')->unique();
            $table->foreignId('user_id')->constrained('users');
            $table->foreignId('slot_id')->constrained('parking_slot');
            $table->datetime('booking_time');
            $table->datetime('expired_time')->nullable();
            $table->datetime('check_in_time')->nullable();
            $table->datetime('check_out_time')->nullable();
            $table->integer('total_payment')->default(0);
            $table->enum('status', ['pending_dp', 'active', 'checked_in', 'completed', 'expired'])->default('pending_dp');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('booking');
    }
};