package com.example.remindery;

import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

public class ReminderHolder extends RecyclerView.ViewHolder {

    public TextView title,subtitle,time;


    public ReminderHolder(@NonNull View itemView) {
        super(itemView);
        title = (TextView)itemView.findViewById(R.id.title);
        subtitle = (TextView)itemView.findViewById(R.id.subtitle);
        time = (TextView)itemView.findViewById(R.id.time);
    }

}
