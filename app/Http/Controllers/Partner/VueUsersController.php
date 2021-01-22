<?php

namespace App\Http\Controllers\Partner;

use App\Http\Controllers\Controller;
use App\Http\Requests\Partner\UsersIndex;
use App\Models\PartnerUser;

class VueUsersController extends Controller
{
    /**
     * Show list of Users.
     *
     * @return \Illuminate\Contracts\Foundation\Application|\Illuminate\Contracts\View\Factory|\Illuminate\Contracts\View\View|\Illuminate\Http\Response
     */
    public function index()
    {
        return view('partner.vue_users.index');
    }

    /**
     * API methods
     */
    public function users(UsersIndex $request)
    {
        $where = function($q) use ($request) {
            if ($request->filter == 'admin') {
                $q->where('role', PartnerUser::ADMIN);
            }
            else if ($request->filter == 'moderator') {
                $q->where('role', PartnerUser::MODERATOR);
            }
            else {
                $q->where('role', PartnerUser::GUEST);
            }
        };

        return response()->json([
            'result' => 'success',
            'users' => PartnerUser::where($where)->orderBy('id', 'desc')->get(),
        ]);
    }
}
