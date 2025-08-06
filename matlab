fsldir = getenv('FSLDIR');
fslmatlab = sprintf('%s/etc/matlab', fsldir);
addpath(fslmatlab);

edit(fullfile(userpath,'startup.m'))


%% สคริปต์สำหรับโหลดและแสดงผลภาพ Skull-Stripped T1-Weighted MRI
% -------------------------------------------------------------------------
% Workflow:
% 1. ตั้งค่า Path ไปยังไฟล์ภาพสมอง
% 2. ใช้ฟังก์ชัน read_avw ของ FSL เพื่อโหลดข้อมูลภาพเข้ามาใน MATLAB
% 3. เลือกสไลซ์ (Slice) ที่ต้องการแสดงผลจากข้อมูล 3 มิติ
% 4. ใช้คำสั่งของ MATLAB เพื่อแสดงภาพสไลซ์นั้น
% -------------------------------------------------------------------------

clear;
clc;
close all; % ปิดหน้าต่างรูปภาพเก่าๆ ทั้งหมด

%% --- ขั้นตอนที่ 1: ตั้งค่าไฟล์ ---
% !!! แก้ไขที่อยู่ไฟล์ตรงนี้ ให้เป็นที่ที่คุณเก็บไฟล์ T1_brain.nii.gz !!!
file_path = 'C:\MyProject\T1_brain.nii.gz';

% ตรวจสอบว่าไฟล์มีอยู่จริงหรือไม่
if ~exist(file_path, 'file')
    error('หาไฟล์ไม่เจอ! กรุณาตรวจสอบ Path: %s', file_path);
end

%% --- ขั้นตอนที่ 2: โหลดข้อมูลภาพด้วย read_avw ---
fprintf('กำลังโหลดไฟล์: %s\n', file_path);

% read_avw จะคืนค่าออกมาเป็น Matrix ข้อมูลภาพ (img) และข้อมูลอื่นๆ
% เช่น ขนาดของภาพ (dims), ขนาด voxel (scales)
[img, dims, scales, bpp, endian] = read_avw(file_path);

fprintf('โหลดข้อมูลสำเร็จ! ขนาดภาพ (dims): %d x %d x %d\n', dims(1), dims(2), dims(3));


%% --- ขั้นตอนที่ 3: เลือกสไลซ์ที่จะแสดงผล ---
% ข้อมูลภาพสมองเป็นแบบ 3 มิติ เราต้องเลือกแสดงผลทีละ 2 มิติ (สไลซ์)
% เราจะเลือกแสดงผล 3 มุมมองหลัก คือ Axial, Coronal, และ Sagittal

% 1. Axial View (มองจากบนลงล่าง)
axial_slice_index = round(dims(3) / 2); % เลือกสไลซ์แกน Z ตรงกลาง
axial_img = rot90(img(:, :, axial_slice_index)); % หมุนภาพ 90 องศาเพื่อให้แสดงผลถูกต้อง

% 2. Coronal View (มองจากหน้าไปหลัง)
coronal_slice_index = round(dims(2) / 2); % เลือกสไลซ์แกน Y ตรงกลาง
coronal_img = rot90(squeeze(img(:, coronal_slice_index, :))); % squeeze เพื่อลดมิติที่ไม่จำเป็น

% 3. Sagittal View (มองจากด้านข้าง)
sagittal_slice_index = round(dims(1) / 2); % เลือกสไลซ์แกน X ตรงกลาง
sagittal_img = rot90(squeeze(img(sagittal_slice_index, :, :)));


%% --- ขั้นตอนที่ 4: แสดงผลภาพใน MATLAB ---
fprintf('กำลังแสดงผลภาพ...\n');

% สร้างหน้าต่าง Figure ใหม่
figure('Name', 'Skull-Stripped T1-Weighted MRI', 'NumberTitle', 'off');

% แสดงผลแบบ 3 มุมมองในหน้าต่างเดียวกัน
subplot(1, 3, 1); % แบ่งหน้าต่างเป็น 1 แถว 3 คอลัมน์, เลือกตำแหน่งที่ 1
imagesc(axial_img);
title(sprintf('Axial View (Slice %d)', axial_slice_index));
colormap('gray'); % ใช้โทนสีเทา
axis image; axis off; % ปรับอัตราส่วนและเอาแกนตัวเลขออก

subplot(1, 3, 2); % เลือกตำแหน่งที่ 2
imagesc(coronal_img);
title(sprintf('Coronal View (Slice %d)', coronal_slice_index));
colormap('gray');
axis image; axis off;

subplot(1, 3, 3); % เลือกตำแหน่งที่ 3
imagesc(sagittal_img);
title(sprintf('Sagittal View (Slice %d)', sagittal_slice_index));
colormap('gray');
axis image; axis off;
