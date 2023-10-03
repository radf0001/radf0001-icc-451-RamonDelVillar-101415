package com.example.tarea4;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Paint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import androidx.recyclerview.widget.ListAdapter;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.DiffUtil;
import androidx.recyclerview.widget.RecyclerView;
import com.example.tarea4.data.TareaViewModel;
import com.example.tarea4.entities.Tarea;
import org.jetbrains.annotations.NotNull;

import java.util.List;

public class TareaListAdapter extends ListAdapter<Tarea, TareaListAdapter.TareaViewHolder> {

    private static TareaViewModel db = null;
    private final MainActivity activity;

    public TareaListAdapter(@NonNull @NotNull DiffUtil.ItemCallback<Tarea> diffCallback, TareaViewModel db, MainActivity activity) {
        super(diffCallback);
        TareaListAdapter.db = db;
        this.activity = activity;
    }

    @NonNull
    @NotNull
    @Override
    public TareaListAdapter.TareaViewHolder onCreateViewHolder(@NonNull @NotNull ViewGroup parent, int viewType) {
        return TareaListAdapter.TareaViewHolder.create(parent);
    }

    @Override
    public void onBindViewHolder(@NonNull @NotNull TareaListAdapter.TareaViewHolder holder, int position) {
        Tarea current = getItem(position);
        holder.bind(current);
    }


    public static class TareaDiff extends DiffUtil.ItemCallback<Tarea> {

        @Override
        public boolean areItemsTheSame(@NonNull Tarea oldItem, @NonNull Tarea newItem) {
            return oldItem == newItem;
        }

        @Override
        public boolean areContentsTheSame(@NonNull Tarea oldItem, @NonNull Tarea newItem) {
            return oldItem.getTask().equals(newItem.getTask());
        }
    }

    static class TareaViewHolder extends RecyclerView.ViewHolder {
        private final CheckBox task;
        private final ImageView iconImage;

        private TareaViewHolder(View itemView) {
            super(itemView);
            task = itemView.findViewById(R.id.todoCheckBox);
            iconImage = itemView.findViewById(R.id.iconImageView);
        }

        public void bind(Tarea item) {
            iconImage.setColorFilter(Color.parseColor(item.getColor()));
            task.setText(item.getTask());
            task.setChecked(item.isStatus());
            if (item.isStatus()) {
                task.setPaintFlags(task.getPaintFlags() | Paint.STRIKE_THRU_TEXT_FLAG);
            } else {
                task.setPaintFlags(task.getPaintFlags() & (~ Paint.STRIKE_THRU_TEXT_FLAG));
            }
            task.setTag(item);
            task.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    CheckBox cb = (CheckBox) view;
                    Tarea tarea = (Tarea) cb.getTag();
                    db.updateStatus(tarea.getId());
                }
            });
        }

        static TareaViewHolder create(ViewGroup parent) {
            View view = LayoutInflater.from(parent.getContext())
                    .inflate(R.layout.recyclerview_item, parent, false);
            return new TareaViewHolder(view);
        }
    }

    public Context getContext() {
        return activity;
    }

    public void deleteItem(int position) {
        Tarea item = db.getAllTareas().getValue().get(position);
        db.deleteById(item.getId());
    }

    public void editItem(int position) {
        Tarea item = db.getAllTareas().getValue().get(position);
        Intent intent = new Intent(activity, NewTaskActivty.class);
        intent.putExtra("id", item.getId());
        intent.putExtra("task", item.getTask());
        activity.tareaActivityResultLauncher.launch(intent);
    }

//    public void cancelDeleteItem(int position) {
//        Tarea item = db.getAllTareas().getValue().get(position);
//        db.updateTask(item.getTask(), item.getId());
//    }
}
