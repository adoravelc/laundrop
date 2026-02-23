<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Carbon\Carbon;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $now = Carbon::now();

        // 1. SEEDER USERS (Sesuai Persona Dokumentasi)
        DB::table('users')->insert([
            [
                'first_name' => 'Evelyn',
                'last_name' => 'Stephanie',
                'role' => 'admin',
                'email' => 'admin_eve@laundrop.com',
                'password' => Hash::make('ad123456'),
                'phone_number' => '081111111111',
                'address' => 'Jl. Ngagel Jaya Tengah No. 15, Surabaya', // Outlet Laundry
                'avatar_url' => null,
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'first_name' => 'Benjamin',
                'last_name' => 'Wang',
                'role' => 'customer',
                'email' => 'ben9@gmail.com',
                'password' => Hash::make('ben123456'),
                'phone_number' => '082222222222',
                'address' => 'Apartemen Puncak Permai, Surabaya',
                'avatar_url' => null,
                'created_at' => $now,
                'updated_at' => $now,
            ]
        ]);

        // 2. SEEDER ADDRESSES (Alamat Penjemputan Ben)
        DB::table('addresses')->insert([
            [
                'users_idusers' => 2, // ID-nya Ben
                'address_detail' => 'Tower A, Unit 1205, Apartemen Puncak Permai, Surabaya Barat',
                'is_default' => 1,
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'users_idusers' => 2,
                'address_detail' => 'Gedung Pakuwon Tower, Lt. 15, Tunjungan Plaza, Surabaya', // Alamat Kantor Ben
                'is_default' => 0,
                'created_at' => $now,
                'updated_at' => $now,
            ]
        ]);

        // 3. SEEDER CATEGORIES
        DB::table('categories')->insert([
            ['name' => 'Kiloan Reguler', 'created_at' => $now, 'updated_at' => $now],
            ['name' => 'Satuan Premium (Dry Clean)', 'created_at' => $now, 'updated_at' => $now],
        ]);

        // 4. SEEDER SERVICES
        DB::table('services')->insert([
            [
                'categories_idcategories' => 1,
                'name' => 'Cuci Kering + Setrika',
                'price' => 8000,
                'unit' => 'kg',
                'estimate_days' => 2,
                'is_active' => 1,
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'categories_idcategories' => 1,
                'name' => 'Cuci Kering Express (1 Hari)',
                'price' => 12000,
                'unit' => 'kg',
                'estimate_days' => 1,
                'is_active' => 1,
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'categories_idcategories' => 2,
                'name' => 'Dry Clean Jas / Blazer',
                'price' => 25000,
                'unit' => 'pcs',
                'estimate_days' => 3,
                'is_active' => 1,
                'created_at' => $now,
                'updated_at' => $now,
            ]
        ]);

        // 5. SEEDER ORDERS (Skenario: Ben pesan laundry 3 hari lalu dan sudah selesai)
        $orderId = DB::table('orders')->insertGetId([
            'users_idusers' => 2, // Ben
            'addresses_idaddresses' => 1, // Diambil dari Apartemen
            'total_amount' => 49000,
            'status' => 'delivered',
            'pickup_schedule' => Carbon::now()->subDays(3)->setHour(9)->setMinute(0),
            'payment_status' => 'paid',
            'notes' => 'Titip di resepsionis apartemen ya. Tolong jasnya di-hanger.',
            'created_at' => Carbon::now()->subDays(3),
            'updated_at' => $now,
        ], 'idorders');

        // 6. SEEDER ORDER DETAILS
        DB::table('order_details')->insert([
            [
                'orders_idorders' => $orderId,
                'services_idservices' => 1, // Cuci Kering Setrika
                'quantity' => 3.00, // 3 kg
                'price_at_order' => 8000,
                'subtotal' => 24000,
            ],
            [
                'orders_idorders' => $orderId,
                'services_idservices' => 3, // Dry Clean Jas
                'quantity' => 1.00, // 1 Pcs
                'price_at_order' => 25000,
                'subtotal' => 25000,
            ]
        ]);

        // 7. SEEDER ORDER LOGS (Audit Trail yang membuktikan status berubah bertahap)
        DB::table('order_logs')->insert([
            [
                'orders_idorders' => $orderId,
                'created_by' => 1, // Diupdate oleh Admin (Angel)
                'status' => 'picking_up',
                'description' => 'Kurir sedang menuju ke alamat penjemputan.',
                'created_at' => Carbon::now()->subDays(3)->addHours(1),
            ],
            [
                'orders_idorders' => $orderId,
                'created_by' => 1,
                'status' => 'processing',
                'description' => 'Pakaian sudah ditimbang dan mulai dicuci.',
                'created_at' => Carbon::now()->subDays(3)->addHours(4),
            ],
            [
                'orders_idorders' => $orderId,
                'created_by' => 1,
                'status' => 'ready',
                'description' => 'Pakaian sudah bersih, rapi, dan siap diantar.',
                'created_at' => Carbon::now()->subDays(1),
            ],
            [
                'orders_idorders' => $orderId,
                'created_by' => 1,
                'status' => 'delivered',
                'description' => 'Pakaian telah diserahkan ke resepsionis apartemen.',
                'created_at' => Carbon::now()->subMinutes(30), // Baru saja diantar
            ]
        ]);

        // 8. SEEDER PAYMENTS
        DB::table('payments')->insert([
            'orders_idorders' => $orderId,
            'amount' => 49000,
            'method' => 'qris',
            'status' => 'success',
            'transaction_id' => 'TRX-QRIS-99887766',
            'paid_at' => Carbon::now()->subDays(3)->addHours(2), // Dibayar setelah baju ditimbang
        ]);

        // 9. SEEDER REVIEWS (Karena barang sudah delivered)
        DB::table('reviews')->insert([
            'orders_idorders' => $orderId,
            'star' => 5,
            'description' => 'Aplikasi Laundrop sangat membantu! Jas saya wangi dan jasnya nggak lecek sama sekali. Kurirnya juga ramah pas ambil di apartemen.',
            'created_at' => $now,
            'updated_at' => $now,
        ]);
    }
}
