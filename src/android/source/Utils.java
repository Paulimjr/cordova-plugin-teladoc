package com.fidelidade.teladoc;

import android.content.Context;
import android.graphics.Color;
import android.util.Base64;
import android.util.Log;

import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PublicKey;
import java.security.spec.X509EncodedKeySpec;
import java.util.Random;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

/**
 * Created by pcamilo on 03/06/2020.
 */
class Utils {

    /**
     * Generate the phone number
     * 
     * @return
     */
    public String generatePhoneNumber() {
        Random ran = new Random();
        StringBuilder phoneNumber = new StringBuilder();
        for (int i = 0; i < 10; i++) {
            phoneNumber.append(ran.nextInt(8));
        }
        return phoneNumber.toString();
    }

    /**
     * Encrypt the value
     * 
     * @param plain
     * @param context
     * @return
     * @throws NoSuchAlgorithmException
     * @throws NoSuchPaddingException
     * @throws InvalidKeyException
     * @throws IllegalBlockSizeException
     * @throws BadPaddingException
     */
    public byte[] encrypt(String plain, Context context) throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException {
        PublicKey key = getKey("MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAn454Jva8HKSz5HUpsIE61/YS4zavmMDUhYIsmpxkIQWBrnmwxfP4zEGI+5P5SfymJFaQsvh23w6fY1DQNB1FAM4mKKOu9l6yPYxEJhU6JH3dnbrzzvkcbD1koEms2xHOnmjI1P3cRCwC83OZY1VL9sZcuACquAKp51prpDYUwWMzst+Tx90M1XRmzsGIyEDDfBBDaoalIFAzHU963myFFo7ztBvg80gWOd7xArLc6vUkOCj85vaRwkP/891H2EtsfmPy+MuTVxxmvX51n+lJ7zFksO3HDjAO++Pw5U1BS9wBZzWFd9Q3xFmIRfc5SnxyxsatFmtcQVBtcIolSqInbXc9LfFQyoY8uBgCqAsHMcrnp5bS/SQFjW7+5jPTSbbSVvHygAdF3OHsQ/lvqjDVFftFkDWUAdQK/sPMHXHVVlWyuurQ2IPux2FioaUXqsYlVWnRbb+Zxg/w24CCoL1wqV+npSXyOpNDO22nMgERUkoxZpGCxWMhexYndGf0XzGPa2q59nRx3nLwR2gWVfvAzhCtOpBh68kt0YHMb/eUJAS4c2NnigOCfLmRAj2k+9KkBc60h57AIUbElbbPRY/0KZisl0o4Gm6d0rBYlDbSRjNXEcie4FSF1HC7guU/T/pL/4R0mGnV4aY4TME3A9/nT0JNTak4SRs6uZWu1udyRz8CAwEAAQ==");
        Cipher cipher = Cipher.getInstance("RSA/None/PKCS1Padding");
        cipher.init(Cipher.ENCRYPT_MODE, key);

        return cipher.doFinal(plain.getBytes());
    }

    /**
     * Get the public key
     * 
     * @param key
     * @return
     */
    private PublicKey getKey(String key) {
        try {
            byte[] decoded = Base64.decode(key, Base64.DEFAULT);
            X509EncodedKeySpec X509publicKey = new X509EncodedKeySpec(decoded);
            KeyFactory kf = KeyFactory.getInstance("RSA");

            return kf.generatePublic(X509publicKey);
        } catch(Exception e) {
            android.util.Log.i("Utils", "getKey error: " + e.getMessage() );
        }
        return null;
    }

    /**
     * Convert hexadecimal string to color
     *
     * @param colorHexadecimal the color ex: #000000
     * @return the Integer color
     */
    public int convertStringToColor(String colorHexadecimal) {
        try {
            return Color.parseColor(colorHexadecimal);
        } catch (IllegalArgumentException e) {
            Log.v("Color exception", e.getMessage());
            return Color.GRAY;
        }
    }
}
