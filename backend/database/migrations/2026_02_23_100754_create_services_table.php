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
        Schema::create('services', function (Blueprint $table) {
            $table->id('idservices');
            $table->unsignedBigInteger('categories_idcategories');
            $table->foreign('categories_idcategories')->references('idcategories')->on('categories')->onDelete('cascade');
            $table->string('name', 255);
            $table->decimal('price', 10, 2);
            $table->enum('unit', ['kg', 'pcs', 'm2']);
            $table->integer('estimate_days');
            $table->tinyInteger('is_active')->default(1);
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('services');
    }
};
