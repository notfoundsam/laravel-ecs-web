<?php

use App\Http\Controllers\Admin\Auth\LoginController;
use App\Http\Controllers\Admin\UsersController;
use App\Http\Controllers\Admin\VueUsersController;
use Illuminate\Support\Facades\Route;

/**
 * Admin auth routes
 */
Route::group(['prefix' => 'admin', 'as' => 'admin.'], function () {
    Route::view('login', 'admin.auth.login')->name('login');
    Route::post('login', [LoginController::class, 'authenticate'])->name('login');
    Route::post('logout', [LoginController::class, 'logout'])->name('logout');
});

/**
 * Admin routes
 */
Route::group(['prefix' => 'admin', 'as' => 'admin.', 'middleware' => ['auth:admin', 'admin.active']], function () {

    // Users
    Route::resource('users', UsersController::class)
            ->only(['index', 'create', 'store'])->middleware(['admin.su']);

    // Vue Users
    Route::resource('vue_users', VueUsersController::class)->only(['index'])->middleware(['admin.su']);

    /**
     * AJAX routes
     */
    Route::group(['prefix' => 'ajax', 'as' => 'ajax.'], function () {

        Route::group(['prefix' => 'vue_users', 'as' => 'vue_users.'], function () {
            Route::get('/', [VueUsersController::class, 'users']);
            Route::put('/{id}', [VueUsersController::class, 'update'])->middleware(['admin.su']);
        });
    });
});
