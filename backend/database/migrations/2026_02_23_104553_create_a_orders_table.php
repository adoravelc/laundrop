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
        Schema::create('orders', function (Blueprint $table) {
            $table->id('idorders');
            $table->unsignedBigInteger('users_idusers');
            $table->unsignedBigInteger('addresses_idaddresses');
            $table->decimal('total_amount', 12, 2)->default(0);
            $table->enum('status', ['pending', 'picking_up', 'processing', 'ready', 'delivered'])->default('pending');
            $table->timestamp('pickup_schedule')->nullable();
            $table->enum('payment_status', ['unpaid', 'paid', 'failed'])->default('unpaid');
            $table->text('notes')->nullable();
            $table->timestamps();

            // Foreign Keys
            $table->foreign('users_idusers')->references('idusers')->on('users')->onDelete('cascade');
            $table->foreign('addresses_idaddresses')->references('idaddresses')->on('addresses')->onDelete('restrict');
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('orders');
    }
};
