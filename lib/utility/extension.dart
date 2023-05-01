import 'dart:math';

int generateRandomNumber(){
  Random random = new Random();
  int randomNumber = random.nextInt(100);
  return randomNumber;// from 0 upto 99 included
}