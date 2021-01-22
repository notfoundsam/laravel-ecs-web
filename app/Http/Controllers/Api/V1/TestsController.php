<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\Test;

class TestsController extends Controller
{
    /**
     * API methods
     */
    public function currency(Test $request)
    {
        if ($request->development) {
            return response()->json(['message' => $request->development]);
        }

        return response()->json(['message' => 'Service Unavailable'], 503);
    }
}
