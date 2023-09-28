package com.example.hoy;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import com.example.hoy.api.APIClient;
import com.example.hoy.api.APIInterface;
import com.example.hoy.dto.User;
import com.example.hoy.dto.UserSingle;
import org.jetbrains.annotations.NotNull;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

import java.util.List;

public class RecyclerAdapter extends RecyclerView.Adapter<RecyclerAdapter.RecyclerViewHolder> {

    public static final String EXTRA_MESSAGE = "com.example.hoy.MESSAGE";
    private final List<User> users;

    public RecyclerAdapter(List<User> users) {
        this.users = users;
    }

    @NonNull
    @NotNull
    @Override
    public RecyclerViewHolder onCreateViewHolder(@NonNull @NotNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_recycler, parent, false);

        return new RecyclerViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull @NotNull RecyclerViewHolder holder, int position) {
        User user = users.get(position);
        holder.textViewRecycler.setText(String.format("%s %s", user.getFirstName(), user.getLastName()));
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                holder.api.find(user.getId()).enqueue(new Callback<UserSingle>() {
                    @Override
                    public void onResponse(Call<UserSingle> call, Response<UserSingle> response) {
                        Intent intent = new Intent(holder.itemView.getContext(), Form.class);
                        User tmp = response.body().data;
                        intent.putExtra(EXTRA_MESSAGE, tmp.id + "\n"
                        + tmp.firstName + "\n" + tmp.lastName + "\n" + tmp.email + "\n" + tmp.avatar + "\n");
                        holder.itemView.getContext().startActivity(intent);
                    }

                    @Override
                    public void onFailure(Call<UserSingle> call, Throwable t) {
                        Log.i("onFailure", t.getMessage());
                        call.cancel();
                    }
                });
            }
        });
    }

    @Override
    public int getItemCount() {
        return users.size();
    }

    public static class RecyclerViewHolder extends RecyclerView.ViewHolder {

        TextView textViewRecycler;
        APIInterface api = APIClient.getClient().create(APIInterface.class);

        public RecyclerViewHolder(@NonNull @NotNull View itemView) {
            super(itemView);

            textViewRecycler = itemView.findViewById(R.id.textViewRecycler);
        }
    }

}
