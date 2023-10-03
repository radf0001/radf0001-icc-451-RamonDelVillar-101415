package com.example.tarea4.data;

import android.app.Application;
import androidx.lifecycle.AndroidViewModel;
import androidx.lifecycle.LiveData;
import com.example.tarea4.entities.Tarea;

import java.util.List;

public class TareaViewModel extends AndroidViewModel {
    private TareaRepository mRepository;
    private LiveData<List<Tarea>> mAllTareas;

    public TareaViewModel (Application application) {
        super(application);
        mRepository = new TareaRepository(application);
        mAllTareas = mRepository.getAllTareas();
    }

    public LiveData<List<Tarea>> getAllTareas() { return mAllTareas; }

    public void refresh() { mAllTareas = mAllTareas; }

    public void insert(Tarea tarea) { mRepository.insert(tarea); }

    public void updateStatus(int id) { mRepository.updateStatus(id); }

    public void deleteById(int id) { mRepository.deleteById(id); }

    public void updateTask(String task, int id) { mRepository.updateTask(task, id); }

}
