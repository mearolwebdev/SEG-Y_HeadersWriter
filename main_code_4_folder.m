clc; clear workspace;

% Укажите путь до папки с исходными файлами
input_folder = 'C:\\путь\\Исходные\\'; % Папка с исходными .sgy файлами
% Укажите путь до папки, куда будут записаны новые файлы
output_folder = 'C:\\путь\\Модифицированные\\'; % Папка для сохранения изменённых файлов


% Перебор файлов в зависимости от количества файлов в папке
for j = 1:50
    % Формирование входного имени файла
    filename = sprintf('название_исходного_файла_%01d.sgy', j);
    fullpath = fullfile(input_folder, filename); % Полный путь к файлу
    % Формирование имени для сохранения
    new_filename = sprintf('название_модифицированного_файла%02d.sgy', j);
    new_fullpath = fullfile(output_folder, new_filename);
    copyfile(fullpath, new_fullpath); % копируем исходный файл в новый, чтобы не затереть информацию в исходном

    SEG=altreadsegy(fullpath);
    [tr_smpls, num_tr]=size(SEG); % считываем размер файла

    % Открываем файл в бинарном режиме для чтения 'l' - little-endian
    fid = fopen(new_fullpath, 'r+b', 'l');
    
    if fid == -1
        error('Не удалось открыть файл: %s', new_fullpath);
    end

    % Цикл записи необходимых данных в заголовки
    for i = 1:num_tr
        L=1; % расстояние м-у источником и приёмником
        dx = 100/(num_tr-1);
        cmp_x = (i-1) * dx + 1000;
        sou_x = cmp_x + L./2;
        rec_x = cmp_x - L./2;
    
        cmp_y = (j-1) + 50 + 1000;
        sou_y = cmp_y;
        rec_y = cmp_y;
    
        position_cmp_x = 3200 + 400 + (i-1)*(240 + 2*tr_smpls) + 181 -1;
        fseek(fid, position_cmp_x, 'bof'); % bof - запись с начала файла   
        fwrite(fid, uint64(cmp_x.*1000), 'uint64');
    
        position_cmp_y = position_cmp_x + 4;
        fseek(fid, position_cmp_y, 'bof'); % bof - запись с начала файла   
        fwrite(fid, uint64(cmp_y.*1000), 'uint64');
    
        position_sou_x = 3200 + 400 + (i-1)*(240 + 2*tr_smpls) + 73 -1;
        fseek(fid, position_sou_x, 'bof'); % bof - запись с начала файла   
        fwrite(fid, uint64(sou_x.*1000), 'uint64');
    
        position_sou_y = position_sou_x + 4;
        fseek(fid, position_sou_y, 'bof'); % bof - запись с начала файла   
        fwrite(fid, uint64(sou_y.*1000), 'uint64');
    
        position_rec_x = 3200 + 400 + (i-1)*(240 + 2*tr_smpls) + 81 -1;
        fseek(fid, position_rec_x, 'bof'); % bof - запись с начала файла   
        fwrite(fid, uint64(rec_x.*1000), 'uint64');
    
        position_rec_y = position_rec_x + 4;
        fseek(fid, position_rec_y, 'bof'); % bof - запись с начала файла   
        fwrite(fid, uint64(rec_y.*1000), 'uint64');
    end
    
    % Закрываем файл
    fclose(fid);
end

disp('Файлы успешно изменены и сохранены как новые.');


