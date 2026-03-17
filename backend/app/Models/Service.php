<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Service extends Model
{
    use SoftDeletes;
    protected $primaryKey = 'idservices';

    protected $fillable = [
        'categories_idcategories',
        'name',
        'price',
        'unit',
        'estimate_days',
        'is_active'
    ];

    // Relasi: Satu Layanan dimiliki oleh satu Kategori (Belongs To)
    public function category()
    {
        return $this->belongsTo(Category::class, 'categories_idcategories', 'idcategories');
    }
}