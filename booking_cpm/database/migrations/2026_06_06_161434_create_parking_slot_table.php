<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('parking_slot', function (Blueprint $table) {
            $table->id();
            $table->foreignId('floor_id')->constrained('floor')->onDelete('cascade');
            $table->string('kode_slot', 20);
            $table->enum('status', ['available', 'booked', 'occupied'])->default('available');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('parking_slot');
    }
};