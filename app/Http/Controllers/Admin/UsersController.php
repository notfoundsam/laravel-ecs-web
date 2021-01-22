<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AdminUser;

class UsersController extends Controller
{
    /**
     * Show list of Users.
     *
     * @return \Illuminate\Contracts\Foundation\Application|\Illuminate\Contracts\View\Factory|\Illuminate\Contracts\View\View|\Illuminate\Http\Response
     */
    public function index()
    {
        return view('admin.users.index', [
            'title' => 'Users',
            'users' => AdminUser::all()
        ]);
    }

    /**
     * API methods
     */
}
