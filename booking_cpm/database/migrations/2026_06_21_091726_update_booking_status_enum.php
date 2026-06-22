<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up()
    {
        DB::statement("ALTER TABLE booking MODIFY status ENUM('pending_dp', 'active', 'checked_in', 'completed', 'cancelled') DEFAULT 'pending_dp'");
    }

    public function down()
    {
        DB::statement("ALTER TABLE booking MODIFY status ENUM('pending_dp', 'active', 'checked_in', 'completed') DEFAULT 'pending_dp'");
    }
};