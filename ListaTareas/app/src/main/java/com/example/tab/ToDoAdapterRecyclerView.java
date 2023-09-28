package com.example.tab;
import android.content.Context;
import android.graphics.Color;
import android.graphics.Paint;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.CompoundButton;

import android.widget.ImageView;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

public class ToDoAdapterRecyclerView extends RecyclerView.Adapter<ToDoAdapterRecyclerView.ViewHolder> {

    private List<ToDoModel> todoList;
    private Fragment2 fragment2;

    public ToDoAdapterRecyclerView(Fragment2 fragment2) {
        this.fragment2 = fragment2;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.recyclerview_task_layout, parent, false);
        return new ViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull final ViewHolder holder, int position) {

        final ToDoModel item = todoList.get(position);
        holder.iconImage.setColorFilter(Color.parseColor(item.getColor()));
        holder.task.setText(item.getTask());
        holder.task.setChecked(toBoolean(item.getStatus()));
        if (item.getStatus() == 1) {
            holder.task.setPaintFlags(holder.task.getPaintFlags() | Paint.STRIKE_THRU_TEXT_FLAG);
        } else {
            holder.task.setPaintFlags(holder.task.getPaintFlags() & (~ Paint.STRIKE_THRU_TEXT_FLAG));
        }
        holder.task.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    DataHandler.updateStatus(item.getId(), 1, "recycler");
                    holder.task.setPaintFlags(holder.task.getPaintFlags() | Paint.STRIKE_THRU_TEXT_FLAG);
                } else {
                    DataHandler.updateStatus(item.getId(), 0, "recycler");
                    holder.task.setPaintFlags(holder.task.getPaintFlags() & (~ Paint.STRIKE_THRU_TEXT_FLAG));

                }
            }
        });
    }

    private boolean toBoolean(int n) {
        return n != 0;
    }

    @Override
    public int getItemCount() {
        return todoList.size();
    }

    public Context getContext() {
        return fragment2.getContext();
    }

    public void setTasks(List<ToDoModel> todoList) {
        this.todoList = todoList;
        notifyDataSetChanged();
    }

    public void deleteItem(int position) {
        ToDoModel item = todoList.get(position);
        DataHandler.deleteTask(item.getId(), "recycler");
        notifyItemRemoved(position);
    }

    public void editItem(int position) {
        ToDoModel item = todoList.get(position);
        Bundle bundle = new Bundle();
        bundle.putInt("id", item.getId());
        bundle.putString("task", item.getTask());
        AddNewTaskRecyclerView fragment = new AddNewTaskRecyclerView();
        fragment.setArguments(bundle);
        fragment.show(fragment2.getChildFragmentManager(), AddNewTaskRecyclerView.TAG);
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        CheckBox task;
        ImageView iconImage;

        ViewHolder(View view) {
            super(view);
            task = view.findViewById(R.id.todoCheckBoxRecyclerView);
            iconImage = view.findViewById(R.id.iconImageViewRecyclerView);
        }
    }
}
