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
        Schema::create('reviews', function (Blueprint $table) {
            $table->id('idreviews');
            $table->unsignedBigInteger('orders_idorders');
            $table->double('star'); // Double sesuai ERD
            $table->text('description')->nullable();
            $table->timestamps();

            // Foreign Key
            $table->foreign('orders_idorders')->references('idorders')->on('orders')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('reviews');
    }
};
