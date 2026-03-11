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
        Schema::create('order_logs', function (Blueprint $table) {
            $table->id('idorder_logs');
            $table->unsignedBigInteger('orders_idorders');
            $table->unsignedBigInteger('created_by'); // Ini mengarah ke idusers (admin yang update)
            $table->string('status', 50);
            $table->string('description', 255)->nullable();
            $table->timestamp('created_at')->useCurrent(); // Hanya created_at sesuai ERD

            // Foreign Keys
            $table->foreign('orders_idorders')->references('idorders')->on('orders')->onDelete('cascade');
            $table->foreign('created_by')->references('idusers')->on('users')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('order_logs');
    }
};
