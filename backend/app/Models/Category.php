<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Category extends Model
{
    use SoftDeletes;
    protected $primaryKey = 'idcategories';

    protected $fillable = ['name'];

    // Relasi: Satu Kategori punya banyak Layanan (1 to Many)
    public function services()
    {
        return $this->hasMany(Service::class, 'categories_idcategories', 'idcategories');
    }
}