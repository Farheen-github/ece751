#include <iostream>
#include <fstream>
#include <cstdlib>
#include <string>
#include <math.h>

using namespace std;

union Fp{
	float f;
	int i;
	unsigned int u;
};

int toInt(string s){
	int temp = 0;
	// MSB first
	int size = 32;
	for (int i = 0; i < size; i++){
		temp <<= 1;
		//cout << s[i];
		if (s[i] == '0'){
		}else if (s[i] == '1'){
			temp |= 0x01;
		} else {
			cout << "Error: toInt()\n";
			return -1;
		} 
	}
	//cout << s << '\n';
	//cout << temp << "\n";
	//printf("%u\n", temp);
	return temp;
}

inline float getError(ifstream &file, union Fp ans_fp){
	float temp;
	string buffer;

	getline(file, buffer);
	union Fp temp_fp;
	temp_fp.i = toInt(buffer);	
	temp = abs((temp_fp.f - ans_fp.f)/(ans_fp.f));
	if (!isnan(temp)){
		return temp; 
	} else {
		return 0;
	}
}

int main(int argc, char* argv[]){
	// Opening files
	ifstream ans;
	ans.open("../dumps/ans.txt");

	ifstream aprox_3;
	ifstream aprox_4;
	ifstream aprox_5;
	ifstream aprox_6;
	ifstream aprox_7;
	ifstream aprox_8;
	ifstream aprox_9;
	ifstream aprox_10;
	aprox_3.open("../dumps/aprox_3.txt");
	aprox_4.open("../dumps/aprox_4.txt");
	aprox_5.open("../dumps/aprox_5.txt");
	aprox_6.open("../dumps/aprox_6.txt");
	aprox_7.open("../dumps/aprox_7.txt");
	aprox_8.open("../dumps/aprox_8.txt");
	aprox_9.open("../dumps/aprox_9.txt");
	aprox_10.open("../dumps/aprox_10.txt");

	ifstream drum_3;
	ifstream drum_4;
	ifstream drum_5;
	ifstream drum_6;
	ifstream drum_7;
	ifstream drum_8;
	ifstream drum_9;
	ifstream drum_10;
	drum_3.open("../dumps/drum_3.txt");
	drum_4.open("../dumps/drum_4.txt");
	drum_5.open("../dumps/drum_5.txt");
	drum_6.open("../dumps/drum_6.txt");
	drum_7.open("../dumps/drum_7.txt");
	drum_8.open("../dumps/drum_8.txt");
	drum_9.open("../dumps/drum_9.txt");
	drum_10.open("../dumps/drum_10.txt");

	ifstream foil_3;
	ifstream foil_4;
	ifstream foil_5;
	ifstream foil_6;
	ifstream foil_7;
	ifstream foil_8;
	ifstream foil_9;
	ifstream foil_10;
	foil_3.open("../dumps/foil_3.txt");
	foil_4.open("../dumps/foil_4.txt");
	foil_5.open("../dumps/foil_5.txt");
	foil_6.open("../dumps/foil_6.txt");
	foil_7.open("../dumps/foil_7.txt");
	foil_8.open("../dumps/foil_8.txt");
	foil_9.open("../dumps/foil_9.txt");
	foil_10.open("../dumps/foil_10.txt");
	
	// Averages
	float aprox_3_error = 0;
	float aprox_4_error = 0;
	float aprox_5_error = 0;
	float aprox_6_error = 0;
	float aprox_7_error = 0;
	float aprox_8_error = 0;
	float aprox_9_error = 0;
	float aprox_10_error = 0;
	float aprox_3_error_squared = 0;
	float aprox_4_error_squared = 0;
	float aprox_5_error_squared = 0;
	float aprox_6_error_squared = 0;
	float aprox_7_error_squared = 0;
	float aprox_8_error_squared = 0;
	float aprox_9_error_squared = 0;
	float aprox_10_error_squared = 0;

	float drum_3_error = 0;
	float drum_4_error = 0;
	float drum_5_error = 0;
	float drum_6_error = 0;
	float drum_7_error = 0;
	float drum_8_error = 0;
	float drum_9_error = 0;
	float drum_10_error = 0;
	float drum_3_error_squared = 0;
	float drum_4_error_squared = 0;
	float drum_5_error_squared = 0;
	float drum_6_error_squared = 0;
	float drum_7_error_squared = 0;
	float drum_8_error_squared = 0;
	float drum_9_error_squared = 0;
	float drum_10_error_squared = 0;

	float foil_3_error = 0;
	float foil_4_error = 0;
	float foil_5_error = 0;
	float foil_6_error = 0;
	float foil_7_error = 0;
	float foil_8_error = 0;
	float foil_9_error = 0;
	float foil_10_error = 0;
	float foil_3_error_squared = 0;
	float foil_4_error_squared = 0;
	float foil_5_error_squared = 0;
	float foil_6_error_squared = 0;
	float foil_7_error_squared = 0;
	float foil_8_error_squared = 0;
	float foil_9_error_squared = 0;
	float foil_10_error_squared = 0;

	// Reading files assunimg all are same length (issues here if else)
	string buffer;
	if (ans.is_open()){
		while (ans.peek() != EOF){
			float temp;
			
			// Ans
			getline(ans, buffer);
			union Fp ans_fp;
		        ans_fp.i = toInt(buffer);

			// Aprox_3
			temp = getError(aprox_3, ans_fp);
			aprox_3_error += temp;
			aprox_3_error_squared += temp*temp;	
			
			// Aprox_4
			temp = getError(aprox_4, ans_fp);
			aprox_4_error += temp;
			aprox_4_error_squared += temp*temp;	
			
			// Aprox_5
			temp = getError(aprox_5, ans_fp);
			aprox_5_error += temp;
			aprox_5_error_squared += temp*temp;	
			
			// Aprox_6
			temp = getError(aprox_6, ans_fp);
			aprox_6_error += temp;
			aprox_6_error_squared += temp*temp;	
			
			// Aprox_7
			temp = getError(aprox_7, ans_fp);
			aprox_7_error += temp;
			aprox_7_error_squared += temp*temp;	

			// Aprox_8
			temp = getError(aprox_8, ans_fp);
			aprox_8_error += temp;
			aprox_8_error_squared += temp*temp;	

			// Aprox_9
			temp = getError(aprox_9, ans_fp);
			aprox_9_error += temp;
			aprox_9_error_squared += temp*temp;	
			
			// Aprox_10
			temp = getError(aprox_10, ans_fp);
			aprox_10_error += temp;
			aprox_10_error_squared += temp*temp;	
			
			// Drum_3
			temp = getError(drum_3, ans_fp);
			drum_3_error += temp;
			drum_3_error_squared += temp*temp;
		
			//Drum_4
			temp = getError(drum_4, ans_fp);
			drum_4_error += temp;
			drum_4_error_squared += temp*temp;
	
			//Drum_5
			temp = getError(drum_5, ans_fp);
			drum_5_error += temp;
			drum_5_error_squared += temp*temp;
	
			//Drum_6
			temp = getError(drum_6, ans_fp);
			drum_6_error += temp;
			drum_6_error_squared += temp*temp;
	
			//Drum_7
			temp = getError(drum_7, ans_fp);
			drum_7_error += temp;
			drum_7_error_squared += temp*temp;
	
			//Drum_8
			temp = getError(drum_8, ans_fp);
			drum_8_error += temp;
			drum_8_error_squared += temp*temp;

			//Drum_9
			temp = getError(drum_9, ans_fp);
			drum_9_error += temp;
			drum_9_error_squared += temp*temp;
	
			//Drum_10	
			temp = getError(drum_10, ans_fp);
			drum_10_error += temp;
			drum_10_error_squared += temp*temp;
		
			// Foil_3
			temp = getError(foil_3, ans_fp);
			foil_3_error += temp;
			foil_3_error_squared += temp*temp;

			// Foil_4
			temp = getError(foil_4, ans_fp);
			foil_4_error += temp;
			foil_4_error_squared += temp*temp;

			// Foil_5
			temp = getError(foil_5, ans_fp);
			foil_5_error += temp;
			foil_5_error_squared += temp*temp;

			// Foil_6
			temp = getError(foil_6, ans_fp);
			foil_6_error += temp;
			foil_6_error_squared += temp*temp;

			// Foil_7
			temp = getError(foil_7, ans_fp);
			foil_7_error += temp;
			foil_7_error_squared += temp*temp;

			// Foil_8
			temp = getError(foil_8, ans_fp);
			foil_8_error += temp;
			foil_8_error_squared += temp*temp;

			// Foil_9
			temp = getError(foil_9, ans_fp);
			foil_9_error += temp;
			foil_9_error_squared += temp*temp;

			// Foil_10
			temp = getError(foil_10, ans_fp);
			foil_10_error += temp;
			foil_10_error_squared += temp*temp;

		}
	}

	cout << "aprox_3_error: " << aprox_3_error << '\n';
	cout << "aprox_3_error_squared: " << aprox_3_error_squared << '\n';
	cout << "aprox_4_error: " << aprox_4_error << '\n';
        cout << "aprox_4_error_squared: " << aprox_4_error_squared << '\n';
	cout << "aprox_5_error: " << aprox_5_error << '\n';
        cout << "aprox_5_error_squared: " << aprox_5_error_squared << '\n';
	cout << "aprox_6_error: " << aprox_6_error << '\n';
        cout << "aprox_6_error_squared: " << aprox_6_error_squared << '\n';
	cout << "aprox_7_error: " << aprox_7_error << '\n';
        cout << "aprox_7_error_squared: " << aprox_7_error_squared << '\n';
	cout << "aprox_8_error: " << aprox_8_error << '\n';
        cout << "aprox_8_error_squared: " << aprox_8_error_squared << '\n';
	cout << "aprox_9_error: " << aprox_9_error << '\n';
        cout << "aprox_9_error_squared: " << aprox_9_error_squared << '\n';
	cout << "aprox_10_error: " << aprox_10_error << '\n';
        cout << "aprox_10_error_squared: " << aprox_10_error_squared << '\n';
	
	cout << '\n';

	cout << "drum_3_error: " << drum_3_error << '\n';
	cout << "drum_3_error_squared: " << drum_3_error_squared << '\n';
	cout << "drum_4_error: " << drum_4_error << '\n';
	cout << "drum_4_error_squared: " << drum_4_error_squared << '\n';
	cout << "drum_5_error: " << drum_5_error << '\n';
	cout << "drum_5_error_squared: " << drum_5_error_squared << '\n';
	cout << "drum_6_error: " << drum_6_error << '\n';
	cout << "drum_6_error_squared: " << drum_6_error_squared << '\n';
	cout << "drum_7_error: " << drum_7_error << '\n';
	cout << "drum_7_error_squared: " << drum_7_error_squared << '\n';
	cout << "drum_8_error: " << drum_8_error << '\n';
	cout << "drum_8_error_squared: " << drum_8_error_squared << '\n';
	cout << "drum_9_error: " << drum_9_error << '\n';
	cout << "drum_9_error_squared: " << drum_9_error_squared << '\n';
	cout << "drum_10_error: " << drum_10_error << '\n';
	cout << "drum_10_error_squared: " << drum_10_error_squared << '\n';

	cout << '\n';

	cout << "foil_3_error: " << foil_3_error << '\n';
	cout << "foil_3_error_squared: " << foil_3_error_squared << '\n';
	cout << "foil_4_error: " << foil_4_error << '\n';
        cout << "foil_4_error_squared: " << foil_4_error_squared << '\n';
	cout << "foil_5_error: " << foil_5_error << '\n';
        cout << "foil_5_error_squared: " << foil_5_error_squared << '\n';
	cout << "foil_6_error: " << foil_6_error << '\n';
        cout << "foil_6_error_squared: " << foil_6_error_squared << '\n';
	cout << "foil_7_error: " << foil_7_error << '\n';
        cout << "foil_7_error_squared: " << foil_7_error_squared << '\n';
	cout << "foil_8_error: " << foil_8_error << '\n';
        cout << "foil_8_error_squared: " << foil_8_error_squared << '\n';
	cout << "foil_9_error: " << foil_9_error << '\n';
        cout << "foil_9_error_squared: " << foil_9_error_squared << '\n';
	cout << "foil_10_error: " << foil_10_error << '\n';
	cout << "foil_10_error_squared: " << foil_10_error_squared << '\n';

	// Output to CSV
	cout << aprox_3_error << '\n';
	cout << aprox_3_error_squared << '\n';
	cout << aprox_4_error << '\n';
        cout << aprox_4_error_squared << '\n';
	cout << aprox_5_error << '\n';
        cout << aprox_5_error_squared << '\n';
	cout << aprox_6_error << '\n';
        cout << aprox_6_error_squared << '\n';
	cout << aprox_7_error << '\n';
        cout << aprox_7_error_squared << '\n';
	cout << aprox_8_error << '\n';
        cout << aprox_8_error_squared << '\n';
	cout << aprox_9_error << '\n';
        cout << aprox_9_error_squared << '\n';
	cout << aprox_10_error << '\n';
        cout << aprox_10_error_squared << '\n';
	
	cout << '\n';

	cout << drum_3_error << '\n';
	cout << drum_3_error_squared << '\n';
	cout << drum_4_error << '\n';
	cout << drum_4_error_squared << '\n';
	cout << drum_5_error << '\n';
	cout << drum_5_error_squared << '\n';
	cout << drum_6_error << '\n';
	cout << drum_6_error_squared << '\n';
	cout << drum_7_error << '\n';
	cout << drum_7_error_squared << '\n';
	cout << drum_8_error << '\n';
	cout << drum_8_error_squared << '\n';
	cout << drum_9_error << '\n';
	cout << drum_9_error_squared << '\n';
	cout << drum_10_error << '\n';
	cout << drum_10_error_squared << '\n';

	cout << '\n';

	cout << foil_3_error << '\n';
	cout << foil_3_error_squared << '\n';
	cout << foil_4_error << '\n';
        cout << foil_4_error_squared << '\n';
	cout << foil_5_error << '\n';
        cout << foil_5_error_squared << '\n';
	cout << foil_6_error << '\n';
        cout << foil_6_error_squared << '\n';
	cout << foil_7_error << '\n';
        cout << foil_7_error_squared << '\n';
	cout << foil_8_error << '\n';
        cout << foil_8_error_squared << '\n';
	cout << foil_9_error << '\n';
        cout << foil_9_error_squared << '\n';
	cout << foil_10_error << '\n';
	cout << foil_10_error_squared << '\n';
	
	return 0;
}
