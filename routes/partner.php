<?php

use App\Http\Controllers\Partner\Auth\LoginController;
use App\Http\Controllers\Partner\UsersController;
use App\Http\Controllers\Partner\VueUsersController;
use Illuminate\Support\Facades\Route;

/**
 * Partner auth routes
 */
Route::group(['prefix' => 'partner', 'as' => 'partner.'], function () {
    Route::view('login', 'partner.auth.login')->name('login');
    Route::post('login', [LoginController::class, 'authenticate'])->name('login');
    Route::post('logout', [LoginController::class, 'logout'])->name('logout');
});

/**
 * Partner routes
 */
Route::group(['prefix' => 'partner', 'as' => 'partner.', 'middleware' => ['auth:partner', 'partner.active']], function () {

    // Users
    Route::resource('users', UsersController::class)
            ->only(['index', 'create', 'store'])->middleware(['partner.su']);

    // Vue Users
    Route::resource('vue_users', VueUsersController::class)->only(['index'])->middleware(['partner.su']);

    /**
     * AJAX routes
     */
    Route::group(['prefix' => 'ajax', 'as' => 'ajax.'], function () {

        Route::group(['prefix' => 'vue_users', 'as' => 'vue_users.'], function () {
            Route::get('/', [VueUsersController::class, 'users']);
            Route::put('/{id}', [VueUsersController::class, 'update'])->middleware(['partner.su']);
        });
    });
});
