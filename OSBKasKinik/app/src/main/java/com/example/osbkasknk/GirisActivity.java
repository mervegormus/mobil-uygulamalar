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
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

public class GirisActivity extends AppCompatActivity {
    EditText editEmailGiris, editPasswordGiris;
    Button btnGirisYap;
    TextView txt_kayitSayfasi;

    FirebaseAuth girisYetkisi;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_giris);

        editEmailGiris=findViewById(R.id.editEmailGiris);
        editPasswordGiris=findViewById(R.id.editPasswordGiris);

        btnGirisYap=findViewById(R.id.btnGirisActivity);
        txt_kayitSayfasi=findViewById(R.id.txt_kayitSayfasi);

        girisYetkisi=FirebaseAuth.getInstance();

        txt_kayitSayfasi.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(GirisActivity.this,KaydolActivity.class));
            }
        });

        btnGirisYap.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                final ProgressDialog pdGiris=new ProgressDialog(GirisActivity.this);
                pdGiris.setMessage("Lütfen bekleyin..");
                pdGiris.show();

                String str_emailGiris=editEmailGiris.getText().toString();
                String str_passwordGiris=editPasswordGiris.getText().toString();
                if(TextUtils.isEmpty(str_emailGiris)||TextUtils.isEmpty(str_passwordGiris)){
                    Toast.makeText(GirisActivity.this,"Lütfen bütün alanları doldurun..",Toast.LENGTH_LONG).show();

                }
                else{
                    //Giriş yapma kodları

                    girisYetkisi.signInWithEmailAndPassword(str_emailGiris,str_passwordGiris).addOnCompleteListener
                            (GirisActivity.this, new OnCompleteListener<AuthResult>() {
                        @Override
                        public void onComplete(@NonNull Task<AuthResult> task) {
                            if(task.isSuccessful()){
                                DatabaseReference yolGiris= FirebaseDatabase.getInstance().getReference()
                                        .child("Kullanıcılar").child(girisYetkisi.getCurrentUser().getUid());
                                yolGiris.addValueEventListener(new ValueEventListener() {
                                    @Override
                                    public void onDataChange(@NonNull DataSnapshot snapshot) {
                                        pdGiris.dismiss();
                                        Intent intent =new Intent(GirisActivity.this,AnasayfaActivity.class);
                                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK|Intent.FLAG_ACTIVITY_CLEAR_TASK);
                                        startActivity(intent);
                                        finish();
                                    }

                                    @Override
                                    public void onCancelled(@NonNull DatabaseError error) {
                                        pdGiris.dismiss();


                                    }
                                });
                            }
                            else{
                                pdGiris.dismiss();
                                Toast.makeText(GirisActivity.this,"Giriş başarısız !",Toast.LENGTH_LONG).show();
                            }
                        }
                    });
                }



            }
        });

    }
}