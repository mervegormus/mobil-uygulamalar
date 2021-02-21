package com.example.osbkasknk;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import java.util.HashMap;

public class KaydolActivity extends AppCompatActivity {
    EditText editKullaniciAdi, editEmail,editPassword;
    Button btn_Kaydol;
    TextView txt_girisSayfasi;

    FirebaseAuth yetki;
    DatabaseReference yol;

    ProgressDialog pd;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_kaydol);

        editKullaniciAdi=findViewById(R.id.editKullaniciAdi);
        editEmail=findViewById(R.id.editEmail);
        editPassword=findViewById(R.id.editPassword);
        btn_Kaydol=findViewById(R.id.btnKayıtolActivity);
        txt_girisSayfasi=findViewById(R.id.txt_girisSayfasi);


        yetki=FirebaseAuth.getInstance();

        txt_girisSayfasi.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(KaydolActivity.this,GirisActivity.class));
            }
        });

        btn_Kaydol.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                pd=new ProgressDialog(KaydolActivity.this);
                pd.setMessage("Lütfen Bekleyin..");
                pd.show();

                String str_kullaniciAdi=editKullaniciAdi.getText().toString();
                String str_email=editEmail.getText().toString();
                String str_password=editPassword.getText().toString();

                if(TextUtils.isEmpty(str_kullaniciAdi)||TextUtils.isEmpty(str_email)||TextUtils.isEmpty(str_password)){
                    Toast.makeText(KaydolActivity.this,"Lütfen bütün alanları doldurun..",Toast.LENGTH_LONG).show();
                }
                else if(str_password.length()<6){
                    Toast.makeText(KaydolActivity.this,"Şifre minimum 6 karakter olmalı !",Toast.LENGTH_LONG).show();
                }
                else {
                    //Yeni kullanıcı kaydetme kodunu çağır
                    kaydet(str_kullaniciAdi,str_email,str_password);


                }


            }
        });
    }
    private void kaydet(final String kullaniciAdi, final String email, final String password){
        // Yeni kullanıcı kaydetme
        yetki.createUserWithEmailAndPassword(email,password).addOnCompleteListener(KaydolActivity.this, new OnCompleteListener<AuthResult>() {
            @Override
            public void onComplete(@NonNull Task<AuthResult> task) {
                if(task.isSuccessful()){
                    FirebaseUser firebaseKullanici=yetki.getCurrentUser();

                    String kullaniciId=firebaseKullanici.getUid();

                    yol= FirebaseDatabase.getInstance().getReference().child("Kullanıcılar").child(kullaniciId);

                    HashMap<String, Object> hashMap =new HashMap<>();
                    hashMap.put("id",kullaniciId);
                    hashMap.put("kullaniciAdi",kullaniciAdi.toLowerCase());
                    hashMap.put("email",email);
                    hashMap.put("sifre",password);
                    yol.setValue(hashMap).addOnCompleteListener(new OnCompleteListener<Void>() {
                        @Override
                        public void onComplete(@NonNull Task<Void> task) {
                            if(task.isSuccessful()){
                                pd.dismiss();

                                Intent intent=new Intent(KaydolActivity.this,AnasayfaActivity.class);
                                intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK|Intent.FLAG_ACTIVITY_NEW_TASK);
                                startActivity(intent);
                            }
                        }
                    });
                }
                else {
                    pd.dismiss();
                    Toast.makeText(KaydolActivity.this,"KAYIT BAŞARISIZ",Toast.LENGTH_LONG).show();
                }
            }
        });
    }
}