<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

class CreateApiUsersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('api_users', function (Blueprint $table) {
            $table->id();
            $table->unsignedTinyInteger('active')->default(0);
            $table->string('name');
            $table->string('api_token', 32)->unique()->nullable()->default(null);
            $table->timestamps();
        });

        // Create API test user
        App\Models\ApiUser::create([
            'active' => 1,
            'name' => 'Test token',
            'api_token' => Str::random(32)
        ]);
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('api_users');
    }
}