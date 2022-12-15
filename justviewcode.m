classdef justviewcode < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        ReescaleEditField_2       matlab.ui.control.NumericEditField
        ReescaleEditField_2Label  matlab.ui.control.Label
        Method2DropDown           matlab.ui.control.DropDown
        Method2DropDownLabel      matlab.ui.control.Label
        Method1DropDown           matlab.ui.control.DropDown
        Method1DropDownLabel      matlab.ui.control.Label
        M2Label                   matlab.ui.control.Label
        Image_3                   matlab.ui.control.Image
        M1Label                   matlab.ui.control.Label
        Image_2                   matlab.ui.control.Image
        OriginalLabel             matlab.ui.control.Label
        Image                     matlab.ui.control.Image
        AjustarButton             matlab.ui.control.Button
        LoadImageButton           matlab.ui.control.Button
    end

    
    properties (Access = public)
        A % Imagen cargada
        fullPathOrigin % path del la imagen original
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: LoadImageButton
        function LoadImageButtonPushed(app, event)
            [file, path] = uigetfile({'*.jpg;*.png'}, "Select Image");
            app.fullPathOrigin = strcat(path, file);
            app.A = imread(app.fullPathOrigin);
        end

        % Button pushed function: AjustarButton
        function AjustarButtonPushed(app, event)

            scale = 100/app.ReescaleEditField_2.Value;% factor de modificacion en el tamaño
            methodInterp1 = lower(app.Method1DropDown.Value); % entrada del metodo 1
            methodInterp2 = lower(app.Method2DropDown.Value); % entrada del metodo 2

            F = griddedInterpolant(double(app.A));
            [ sx , sy , sz ] = size(app.A); % dimensiones de la matriz A
            xq = ( 1:scale:sx )';
            yq = ( 1:scale:sy )';
            zq = ( 1:sz )';

            F.Method = methodInterp1;
            vq = uint8(F({ xq , yq , zq })); % se convierte los datos de la matriz de double a uint8
            imwrite(vq, 'm1.png'); % guarda la imagen
            pathDefault = imread("m1.png"); % carga la imagen anteriormente guardada

            F.Method = methodInterp2; % define el metodo de interpolacion
            vq = uint8(F({ xq , yq , zq }));  % crea la nueva imagen con la interpolacion
            imwrite(vq, 'm2.png');
            pathInterpolation = imread("m2.png");

            app.Image.ImageSource = app.fullPathOrigin; % carga de imagen original
            app.Image_2.ImageSource = pathDefault; % muestra la imagen en m1
            app.Image_3.ImageSource = pathInterpolation; % muestra la imagen en m2
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create LoadImageButton
            app.LoadImageButton = uibutton(app.UIFigure, 'push');
            app.LoadImageButton.ButtonPushedFcn = createCallbackFcn(app, @LoadImageButtonPushed, true);
            app.LoadImageButton.BackgroundColor = [0.3804 0.3569 0.851];
            app.LoadImageButton.FontColor = [1 1 1];
            app.LoadImageButton.Position = [33 430 100 23];
            app.LoadImageButton.Text = 'Load Image';

            % Create AjustarButton
            app.AjustarButton = uibutton(app.UIFigure, 'push');
            app.AjustarButton.ButtonPushedFcn = createCallbackFcn(app, @AjustarButtonPushed, true);
            app.AjustarButton.BackgroundColor = [0 0.4471 0.7412];
            app.AjustarButton.FontSize = 14;
            app.AjustarButton.FontColor = [1 1 1];
            app.AjustarButton.Position = [28 17 582 46];
            app.AjustarButton.Text = 'Ajustar';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [29 94 190 206];

            % Create OriginalLabel
            app.OriginalLabel = uilabel(app.UIFigure);
            app.OriginalLabel.Position = [101 299 46 35];
            app.OriginalLabel.Text = 'Original';

            % Create Image_2
            app.Image_2 = uiimage(app.UIFigure);
            app.Image_2.Position = [230 94 190 206];

            % Create M1Label
            app.M1Label = uilabel(app.UIFigure);
            app.M1Label.Position = [315 299 19 35];
            app.M1Label.Text = 'M1';

            % Create Image_3
            app.Image_3 = uiimage(app.UIFigure);
            app.Image_3.Position = [429 94 190 206];

            % Create M2Label
            app.M2Label = uilabel(app.UIFigure);
            app.M2Label.Position = [514 299 19 35];
            app.M2Label.Text = 'M2';

            % Create Method1DropDownLabel
            app.Method1DropDownLabel = uilabel(app.UIFigure);
            app.Method1DropDownLabel.HorizontalAlignment = 'right';
            app.Method1DropDownLabel.Position = [238 383 58 22];
            app.Method1DropDownLabel.Text = 'Method 1:';

            % Create Method1DropDown
            app.Method1DropDown = uidropdown(app.UIFigure);
            app.Method1DropDown.Items = {'Linear', 'Cubic', 'Spline', 'Nearest'};
            app.Method1DropDown.Position = [311 379 100 30];
            app.Method1DropDown.Value = 'Linear';

            % Create Method2DropDownLabel
            app.Method2DropDownLabel = uilabel(app.UIFigure);
            app.Method2DropDownLabel.HorizontalAlignment = 'right';
            app.Method2DropDownLabel.Position = [429 383 58 22];
            app.Method2DropDownLabel.Text = 'Method 2:';

            % Create Method2DropDown
            app.Method2DropDown = uidropdown(app.UIFigure);
            app.Method2DropDown.Items = {'Linear', 'Cubic', 'Spline', 'Nearest'};
            app.Method2DropDown.Position = [502 379 100 30];
            app.Method2DropDown.Value = 'Nearest';

            % Create ReescaleEditField_2Label
            app.ReescaleEditField_2Label = uilabel(app.UIFigure);
            app.ReescaleEditField_2Label.HorizontalAlignment = 'right';
            app.ReescaleEditField_2Label.Position = [47 383 69 22];
            app.ReescaleEditField_2Label.Text = 'Reescale %';

            % Create ReescaleEditField_2
            app.ReescaleEditField_2 = uieditfield(app.UIFigure, 'numeric');
            app.ReescaleEditField_2.Position = [131 383 88 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = justviewcode

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end