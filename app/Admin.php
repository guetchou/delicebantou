<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Admin extends  Authenticatable
{
    use Notifiable;
    protected $fillable=['name','email','password','phone','type','image'];

    protected $hidden = [
        'password'
    ];

}
