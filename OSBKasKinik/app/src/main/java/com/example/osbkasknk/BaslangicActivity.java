package com.example.osbkasknk;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

public class BaslangicActivity extends AppCompatActivity {
    Button btn_baslangicGiris;
    Button btn_baslangicKayit;

    FirebaseUser baslangicKullanici;

    @Override
    protected void onStart() {
        super.onStart();

        baslangicKullanici= FirebaseAuth.getInstance().getCurrentUser();

        //kullanıcı veritabanında varsa direkt anasayfaya gönderir
        if(baslangicKullanici!=null){
            startActivity(new Intent(BaslangicActivity.this,AnasayfaActivity.class));
            finish();
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_baslangic);

        btn_baslangicGiris=findViewById(R.id.btn_giris);
        btn_baslangicKayit=findViewById(R.id.btn_kaydol);

        btn_baslangicGiris.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(BaslangicActivity.this,GirisActivity.class));
            }
        });
        btn_baslangicKayit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(BaslangicActivity.this,KaydolActivity.class));
            }
        });
    }
}