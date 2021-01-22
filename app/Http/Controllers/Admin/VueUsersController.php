<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\UsersIndex;
use App\Models\AdminUser;

class VueUsersController extends Controller
{
    /**
     * Show list of Users.
     *
     * @return \Illuminate\Contracts\Foundation\Application|\Illuminate\Contracts\View\Factory|\Illuminate\Contracts\View\View|\Illuminate\Http\Response
     */
    public function index()
    {
        return view('admin.vue_users.index');
    }

    /**
     * API methods
     */
    public function users(UsersIndex $request)
    {
        $where = function($q) use ($request) {
            if ($request->filter == 'admin') {
                $q->where('role', AdminUser::ADMIN);
            }
            else if ($request->filter == 'moderator') {
                $q->where('role', AdminUser::MODERATOR);
            }
            else {
                $q->where('role', AdminUser::GUEST);
            }
        };

        return response()->json([
            'result' => 'success',
            'users' => AdminUser::where($where)->orderBy('id', 'desc')->get(),
        ]);
    }
}
