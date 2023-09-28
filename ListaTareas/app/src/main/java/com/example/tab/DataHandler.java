package com.example.tab;

import java.util.ArrayList;
import java.util.List;

public class DataHandler {

    static List<ToDoModel> recyclerViewList = new ArrayList<>();
    static List<ToDoModel> listViewList = new ArrayList<>();
    static int idListView = 1;
    static int idRecyclerView = 1;

    public static void insertTask(ToDoModel task, String view){
        if(view.equalsIgnoreCase("list")){
            task.setId(idListView);
            idListView++;
            listViewList.add(task);
        }else{
            task.setId(idRecyclerView);
            idRecyclerView++;
            recyclerViewList.add(task);
        }
    }

    public static List<ToDoModel> getAllTasks(String view){
        if(view.equalsIgnoreCase("list")){
            return listViewList;
        }else{
            return recyclerViewList;
        }
    }

    public static void updateStatus(int id, int status, String view){
        if(view.equalsIgnoreCase("list")){
            for(ToDoModel task : listViewList) {
                if(task!=null && id == task.getId()) {
                    task.setStatus(status);
                    break;
                }
            }
        }else{
            for(ToDoModel task : recyclerViewList) {
                if(task!=null && id == task.getId()) {
                    task.setStatus(status);
                    break;
                }
            }
        }
    }

    public static void updateTask(int id, String task, String view) {
        if(view.equalsIgnoreCase("list")){
            for(ToDoModel tarea : listViewList) {
                if(tarea!=null && id == tarea.getId()) {
                    tarea.setTask(task);
                    break;
                }
            }
        }else{
            for(ToDoModel tarea : recyclerViewList) {
                if(task!=null && id == tarea.getId()) {
                    tarea.setTask(task);
                    break;
                }
            }
        }
    }

    public static void deleteTask(int id, String view) {
        if(view.equalsIgnoreCase("list")){
            listViewList.removeIf(obj -> obj.getId() == id);
        }else{
            recyclerViewList.removeIf(obj -> obj.getId() == id);
        }
    }
}

