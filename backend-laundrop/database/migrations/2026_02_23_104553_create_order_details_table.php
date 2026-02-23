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
        Schema::create('order_details', function (Blueprint $table) {
            $table->id('idorder_details');
            $table->unsignedBigInteger('orders_idorders');
            $table->unsignedBigInteger('services_idservices');
            $table->decimal('quantity', 8, 2);
            $table->decimal('price_at_order', 12, 2);
            $table->decimal('subtotal', 12, 2);

            // Foreign Keys
            $table->foreign('orders_idorders')->references('idorders')->on('orders')->onDelete('cascade');
            $table->foreign('services_idservices')->references('idservices')->on('services')->onDelete('restrict');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('order_details');
    }
};
