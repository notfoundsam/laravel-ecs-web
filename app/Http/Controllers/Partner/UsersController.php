<?php

namespace App\Http\Controllers\Partner;

use App\Http\Controllers\Controller;
use App\Models\PartnerUser;

class UsersController extends Controller
{
    /**
     * Show list of Users.
     *
     * @return \Illuminate\Contracts\Foundation\Application|\Illuminate\Contracts\View\Factory|\Illuminate\Contracts\View\View|\Illuminate\Http\Response
     */
    public function index()
    {
        return view('partner.users.index', [
            'title' => 'Users',
            'users' => PartnerUser::all()
        ]);
    }

    /**
     * API methods
     */

}
