package com.example.osbkasknk;



import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;


import android.app.DatePickerDialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CalendarView;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;


import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import java.util.Calendar;
import java.util.HashMap;


public class AnasayfaActivity extends AppCompatActivity {

    private FirebaseAuth mAuth;
    Button btn;
    Button saveButton;
    DatabaseReference ref;
    EditText tarihEditText,tarihEditText2;
    Spinner spinner1, spinner2, spinner3, spinner4, spinner5,spinner6;


    private ArrayAdapter<String> dataAdapterForMeslek;
    private ArrayAdapter<String> dataAdapterForSera;
    private ArrayAdapter<String> dataAdapterForUrun;
    private ArrayAdapter<String> dataAdapterForKapasite;
    private ArrayAdapter<String> dataAdapterForKisi;
    private ArrayAdapter<String> dataAdapterForIlac;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_anasayfa);
        mAuth = FirebaseAuth.getInstance();
        btn = (Button) findViewById(R.id.button);

        saveButton = (Button) findViewById(R.id.saveButton);
        spinner1 = (Spinner) findViewById(R.id.spinner1);
        spinner2 = (Spinner) findViewById(R.id.spinner2);
        spinner3 = (Spinner) findViewById(R.id.spinner3);
        spinner4 = (Spinner) findViewById(R.id.spinner4);
        spinner5 = (Spinner) findViewById(R.id.spinner5);
        spinner6 = (Spinner) findViewById(R.id.spinner6);

        tarihEditText=findViewById(R.id.tarihEditText);
        tarihEditText2=findViewById(R.id.tarihEditText2);


        final String meslek[] = {"Kamu", "Emekli","Çiftçi","Serbest Meslek","Diğer"};
        final String sera[] = {"Var", "Yok"};
        final String urun[] = {"Elma", "Armut","Portakal","Domates","Marul","Çilek"};
        final String urunKapasite[] = {"0-100ton", "100-200ton","200-300ton","300-500ton","500+ton"};
        final String kisiSayi[] = {"0-10", "10-20","20-30","30-50","50+"};
        final String ilac[] = {"A", "B","C","D","E","F","G"};


        dataAdapterForMeslek = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, meslek);
        dataAdapterForMeslek.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner1.setAdapter(dataAdapterForMeslek);

        dataAdapterForSera = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, sera);
        dataAdapterForSera.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner2.setAdapter(dataAdapterForSera);


        dataAdapterForUrun = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, urun);
        dataAdapterForUrun.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner3.setAdapter(dataAdapterForUrun);


        dataAdapterForKapasite = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, urunKapasite);
        dataAdapterForKapasite.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner4.setAdapter(dataAdapterForKapasite);

        dataAdapterForKisi = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, kisiSayi);
        dataAdapterForKisi.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner5.setAdapter(dataAdapterForKisi);


        dataAdapterForIlac = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, ilac);
        dataAdapterForIlac.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner6.setAdapter(dataAdapterForIlac);



        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mAuth.signOut();
                Intent intent = new Intent(getApplicationContext(), BaslangicActivity.class);
                Toast.makeText(getApplicationContext(), "Oturum Kapatıldı !", Toast.LENGTH_LONG).show();
                startActivity(intent);
            }
        });

        saveButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Object a = spinner1.getSelectedItem();
                Object b = spinner2.getSelectedItem();
                Object c = spinner3.getSelectedItem();
                Object d = spinner4.getSelectedItem();
                Object e = spinner5.getSelectedItem();
                Object f = spinner6.getSelectedItem();
                String tarihilac= tarihEditText.getText().toString();
                String tarihgubre=tarihEditText2.getText().toString();


                gonder(a,b,c,d,e,f,tarihgubre,tarihilac);
            }
        });



    }

    private void gonder(Object a,Object b,Object c,Object d,Object e,Object f,String tarihgubre,String tarihilac) {
        FirebaseUser firebaseKullanici = mAuth.getCurrentUser();
        String kullaniciId = firebaseKullanici.getUid();
        ref = FirebaseDatabase.getInstance().getReference().child("Kullanıcılar").child(kullaniciId).child("Veriler");
        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("meslek", a);
        hashMap.put("sera", b);
        hashMap.put("urun", c);
        hashMap.put("kapasite", d);
        hashMap.put("çalışan kişi", e);
        hashMap.put("gübre", f);
        hashMap.put("gübreTarih", tarihgubre);
        hashMap.put("ilacTarih",tarihilac);


        ref.setValue(hashMap).addOnCompleteListener(new OnCompleteListener<Void>() {
            @Override
            public void onComplete(@NonNull Task<Void> task) {
                if (task.isSuccessful()) {
                    Toast.makeText(AnasayfaActivity.this, "KAYIT BAŞARILI", Toast.LENGTH_LONG).show();
                } else {
                    Toast.makeText(AnasayfaActivity.this, "KAYIT BAŞARISIZ", Toast.LENGTH_LONG).show();
                }
            }
        });

    }
}




