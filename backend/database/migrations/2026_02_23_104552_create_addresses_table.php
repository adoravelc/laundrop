<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('addresses', function (Blueprint $table) {
            $table->id('idaddresses');
            $table->unsignedBigInteger('users_idusers');
            $table->string('address_detail', 255);
            $table->tinyInteger('is_default')->default(0);
            $table->timestamps();

            // Foreign Key
            $table->foreign('users_idusers')->references('idusers')->on('users')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('addresses');
    }
};
