<?php

namespace App\Http\Controllers;

use App\Models\Service;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Database\Eloquent\SoftDeletes;

class ServiceController extends Controller
{
    use SoftDeletes;
    // 1. READ ALL (Nampilin semua layanan, cocok buat homepage Ben)
    public function index()
    {
        // Ambil semua layanan beserta nama kategorinya
        $services = Service::with('category')->get();

        return response()->json([
            'status' => 'success',
            'data' => $services
        ], 200);
    }

    // 2. CREATE (Buat nambah layanan baru oleh Admin)
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'categories_idcategories' => 'required|exists:categories,idcategories',
            'name' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
            'unit' => 'required|in:kg,pcs,m2',
            'estimate_days' => 'required|integer|min:1',
            'is_active' => 'boolean'
        ]);

        if ($validator->fails()) {
            return response()->json(['status' => 'error', 'errors' => $validator->errors()], 422);
        }

        $service = Service::create($request->all());

        return response()->json([
            'status' => 'success',
            'message' => 'Layanan berhasil ditambahkan!',
            'data' => $service
        ], 201);
    }

    // 3. READ ONE (Nampilin 1 detail layanan)
    public function show($id)
    {
        $service = Service::with('category')->find($id);

        if (!$service) {
            return response()->json(['status' => 'error', 'message' => 'Layanan tidak ditemukan'], 404);
        }

        return response()->json([
            'status' => 'success',
            'data' => $service
        ], 200);
    }

    // 4. UPDATE (Ngedit layanan, misal Bu Angel mau naikin harga)
    public function update(Request $request, $id)
    {
        $service = Service::find($id);

        if (!$service) {
            return response()->json(['status' => 'error', 'message' => 'Layanan tidak ditemukan'], 404);
        }

        $validator = Validator::make($request->all(), [
            'categories_idcategories' => 'exists:categories,idcategories',
            'name' => 'string|max:255',
            'price' => 'numeric|min:0',
            'unit' => 'in:kg,pcs,m2',
            'estimate_days' => 'integer|min:1',
            'is_active' => 'boolean'
        ]);

        if ($validator->fails()) {
            return response()->json(['status' => 'error', 'errors' => $validator->errors()], 422);
        }

        $service->update($request->all());

        return response()->json([
            'status' => 'success',
            'message' => 'Layanan berhasil diupdate!',
            'data' => $service
        ], 200);
    }

    // 5. DELETE (Hapus layanan)
    public function destroy($id)
    {
        $service = Service::find($id);

        if (!$service) {
            return response()->json(['status' => 'error', 'message' => 'Layanan tidak ditemukan'], 404);
        }

        $service->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Layanan berhasil dihapus!'
        ], 200);
    }
}