<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens; // Ini wajib untuk API Token

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    // Kasih tau Laravel kalau Primary Key kita bukan 'id'
    protected $primaryKey = 'idusers'; 

    protected $fillable = [
        'first_name',
        'last_name',
        'role',
        'email',
        'password',
        'phone_number',
        'address',
        'avatar_url',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }
}