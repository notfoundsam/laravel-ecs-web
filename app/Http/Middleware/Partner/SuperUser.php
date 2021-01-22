<?php

namespace App\Http\Middleware\Partner;

use App\Models\PartnerUser;
use Closure;

class SuperUser
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        if ($request->user()->role !== PartnerUser::ADMIN) {
            abort(403);
        }

        return $next($request);
    }
}
