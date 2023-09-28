package com.example.hoy.api;
import com.example.hoy.dto.UserList;
import com.example.hoy.dto.UserSingle;
import retrofit2.Call;
import retrofit2.http.*;

import java.util.List;

public interface APIInterface {

    @GET("users")
    Call<UserList> findAll();

    @GET("users/{id}")
    Call<UserSingle> find(@Path("id") int id);


}
