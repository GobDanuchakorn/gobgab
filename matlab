edit(fullfile(userpath,'startup.m'))



fsldir = '\\wsl$\Ubuntu\home\davgob\fsl';

if isfolder(fsldir)
    fsl_matlab_path = fullfile(fsldir, 'etc', 'matlab');
    addpath(fsl_matlab_path);
    fprintf('FSL Path added automatically from startup.m\n');
end



%% ========================================================================
%  สคริปต์สำหรับโหลดและแสดงผลภาพ Skull-Stripped MRI ด้วย MATLAB และ FSL
% =========================================================================

%% --- ส่วนที่ 1: การตั้งค่าเริ่มต้น ---
clear;         % ล้างตัวแปรเก่า
clc;           % ล้างหน้าต่างคำสั่ง
close all;     % ปิดหน้าต่างรูปภาพทั้งหมด

fprintf('เริ่มต้นสคริปต์แสดงผลภาพสมอง...\n');

%% --- ส่วนที่ 2: ตั้งค่า Path และโหลดข้อมูล ---

% !!! แก้ไข Path ตรงนี้ ให้เป็นที่อยู่ไฟล์ T1_brain.nii.gz ของคุณ !!!
file_path = 'C:\MyProject\T1_brain.nii.gz';

% --- ตรวจสอบว่าไฟล์มีอยู่จริงหรือไม่ ---
if ~exist(file_path, 'file')
    error('หาไฟล์ไม่เจอ! กรุณาตรวจสอบ Path ที่ระบุ: %s', file_path);
end

% --- โหลดข้อมูลภาพด้วยฟังก์ชัน read_avw ของ FSL ---
fprintf('กำลังโหลดไฟล์: %s\n', file_path);
% img คือ Matrix ข้อมูลภาพ 3 มิติ
% dims คือขนาดของ Matrix (เช่น [256 256 170])
[img, dims] = read_avw(file_path);
fprintf('โหลดข้อมูลสำเร็จ! ขนาดภาพ: %d x %d x %d\n\n', dims(1), dims(2), dims(3));


%% --- ส่วนที่ 3: เลือกและแสดงผลภาพ 3 มุมมอง ---
fprintf('กำลังเตรียมแสดงผลภาพ...\n');

% --- สร้างหน้าต่าง Figure ใหม่ ---
figure('Name', 'Skull-Stripped T1-Weighted MRI Viewer', 'NumberTitle', 'off', 'Color', 'w');

% --- 1. มุมมอง Axial (มองจากบนลงล่าง) ---
% เลือกสไลซ์แกน Z (แนวตั้ง) ตรงกลาง
axial_slice_index = round(dims(3) / 2);
axial_img = rot90(img(:, :, axial_slice_index)); % หมุนภาพเพื่อให้แสดงผลถูกต้อง

subplot(1, 3, 1); % แบ่งหน้าต่างเป็น 1 แถว 3 คอลัมน์, เลือกตำแหน่งที่ 1
imagesc(axial_img);
title(sprintf('Axial View (Slice %d)', axial_slice_index));
colormap('gray'); % ใช้โทนสีเทาสำหรับภาพ MRI
axis image;       % ปรับอัตราส่วนภาพให้ถูกต้อง
axis off;         % ซ่อนแกนตัวเลข

% --- 2. มุมมอง Coronal (มองจากหน้าไปหลัง) ---
% เลือกสไลซ์แกน Y (แนวลึก) ตรงกลาง
coronal_slice_index = round(dims(2) / 2);
% squeeze() ใช้เพื่อลดมิติของ Matrix ที่ไม่จำเป็นออกไป
coronal_img = rot90(squeeze(img(:, coronal_slice_index, :)));

subplot(1, 3, 2); % เลือกตำแหน่งที่ 2
imagesc(coronal_img);
title(sprintf('Coronal View (Slice %d)', coronal_slice_index));
colormap('gray');
axis image;
axis off;

% --- 3. มุมมอง Sagittal (มองจากด้านข้าง) ---
% เลือกสไลซ์แกน X (แนวนอน) ตรงกลาง
sagittal_slice_index = round(dims(1) / 2);
sagittal_img = rot90(squeeze(img(sagittal_slice_index, :, :)));

subplot(1, 3, 3); % เลือกตำแหน่งที่ 3
imagesc(sagittal_img);
title(sprintf('Sagittal View (Slice %d)', sagittal_slice_index));
colormap('gray');
axis image;
axis off;

fprintf('แสดงผลภาพเรียบร้อย!\n');
