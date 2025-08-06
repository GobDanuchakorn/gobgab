fsldir = getenv('FSLDIR');
fslmatlab = sprintf('%s/etc/matlab', fsldir);
addpath(fslmatlab);

edit(fullfile(userpath,'startup.m'))


%% สคริปต์ทดสอบการรัน FSL BET จาก MATLAB
clear;
clc;

data_folder = 'C:\MyProject';

% กำหนดชื่อไฟล์ Input (ไฟล์ต้นฉบับ)
input_file = fullfile(data_folder, 'T1_image.nii.gz');

% กำหนดชื่อไฟล์ Output (ไฟล์ที่จะให้ FSL สร้างขึ้น)
output_file = fullfile(data_folder, 'T1_brain.nii.gz');

% ตรวจสอบว่าไฟล์ Input มีอยู่จริงหรือไม่
if ~exist(input_file, 'file')
    error('หาไฟล์ Input ไม่เจอ! กรุณาตรวจสอบ Path และชื่อไฟล์: %s', input_file);
end

% --- 2. สร้างและรันคำสั่ง FSL ---
fprintf('กำลังเตรียมรัน FSL BET...\n');

% สร้างสตริงคำสั่ง FSL โดยใช้รูปแบบ: bet <input> <output>
fsl_command = sprintf('bet %s %s', input_file, output_file);

% แสดงคำสั่งที่เราจะรันให้ดู
disp(['   คำสั่งที่จะรัน: ' fsl_command]);

% ใช้ฟังก์ชัน system() ของ MATLAB เพื่อสั่งรันคำสั่งใน Command Line
status = system(fsl_command);

% --- 3. ตรวจสอบผลลัพธ์ ---
if status == 0 && exist(output_file, 'file')
    fprintf('\n✅ รัน FSL BET สำเร็จ!\n');
    fprintf('   ไฟล์ผลลัพธ์ถูกสร้างที่: %s\n', output_file);
else
    fprintf('\n❌ เกิดข้อผิดพลาดในการรัน FSL!\n');
end
