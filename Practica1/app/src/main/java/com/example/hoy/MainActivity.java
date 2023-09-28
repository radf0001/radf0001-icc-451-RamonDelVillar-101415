package com.example.hoy;


import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Parcelable;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.hoy.api.APIClient;
import com.example.hoy.api.APIInterface;
import com.example.hoy.databinding.ActivityMainBinding;
import com.example.hoy.dto.User;
import com.example.hoy.dto.UserList;
import com.example.hoy.dto.UserSingle;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {
    ActivityMainBinding binding;
    Context context = this;
    public static List<User> data;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());


        APIInterface api = APIClient.getClient().create(APIInterface.class);

        Button button = findViewById(R.id.button);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                api.findAll().enqueue(new Callback<UserList>() {
                    @Override
                    public void onResponse(Call<UserList> call, Response<UserList> response) {
                        data = response.body().data;
                        Intent intent = new Intent(context, RecyclerActivity.class);
                        startActivity(intent);
                    }

                    @Override
                    public void onFailure(Call<UserList> call, Throwable t) {
                        Log.w("onFailure", t.getLocalizedMessage());
                        call.cancel();
                    }
                });
            }
        });

//        api.findAll().enqueue(new Callback<UserList>() {
//            @Override
//            public void onResponse(Call<UserList> call, Response<UserList> response) {
//                Log.w("onResponse", response.body().data.toString());
//            }
//
//            @Override
//            public void onFailure(Call<UserList> call, Throwable t) {
//                Log.w("onFailure", t.getLocalizedMessage());
//                call.cancel();
//            }
//        });


//        api.findAll().enqueue(new Callback<UserList>() {
//            @Override
//            public void onResponse(Call<UserList> call, Response<UserList> response) {
//                Log.d("onResponse", response.code() + "");
//            }
//
//            @Override
//            public void onFailure(Call<UserList> call, Throwable t) {
//                Log.i("onFailure", t.getMessage());
//                call.cancel();
//            }
//        });
//
//        api.find(1).enqueue(new Callback<UserSingle>() {
//            @Override
//            public void onResponse(Call<UserSingle> call, Response<UserSingle> response) {
//                Log.d("onResponse", response.code() + "");
//            }
//
//            @Override
//            public void onFailure(Call<UserSingle> call, Throwable t) {
//                Log.i("onFailure", t.getMessage());
//                call.cancel();
//            }
//        });


    }
}