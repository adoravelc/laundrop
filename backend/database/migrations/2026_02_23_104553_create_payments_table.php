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
        Schema::create('payments', function (Blueprint $table) {
            $table->id('idpayments');
            $table->unsignedBigInteger('orders_idorders');
            $table->decimal('amount', 12, 2);
            $table->enum('method', ['cash', 'transfer', 'ewallet', 'qris']);
            $table->enum('status', ['pending', 'success', 'failed'])->default('pending');
            $table->string('transaction_id', 255)->nullable();
            $table->timestamp('paid_at')->nullable();

            // Foreign Key
            $table->foreign('orders_idorders')->references('idorders')->on('orders')->onDelete('cascade');
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('payments');
    }
};
