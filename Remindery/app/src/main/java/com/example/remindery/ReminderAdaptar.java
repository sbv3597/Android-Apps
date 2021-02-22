package com.example.remindery;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;

public class ReminderAdaptar extends RecyclerView.Adapter<ReminderHolder> {

    private Context context;
    private ArrayList<ReminderModel> reminders;

    public ReminderAdaptar(Context context, ArrayList<ReminderModel> reminders) {
        this.context = context;
        this.reminders = reminders;
        Log.i("shubham", reminders.size() + " ");
    }

    @NonNull
    @Override
    public ReminderHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.reminder_card, parent, false);
        Log.i("shubham", reminders.size() + " holder created" );
        return new ReminderHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ReminderHolder holder, int position) {
        Log.i("shubham", reminders.size() + " " + position);
        ReminderModel reminder = reminders.get(position);
        Log.i("shubham", reminder.getTitle() + " " + position);
if(reminder.getTitle() != null)
        holder.title.setText(reminder.getTitle());
        if(reminder.getDescription() != null)
        holder.subtitle.setText(reminder.getDescription());
        if(reminder.getTime() != null)
        holder.time.setText(reminder.getTime());

    }

    @Override
    public int getItemCount() {
        return reminders.size();
    }
}
