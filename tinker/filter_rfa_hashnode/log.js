import { createLogger, format, transports } from 'winston';
const { combine, timestamp, printf } = format;

const logFormat = printf(({ timestamp, level, message}) => {
    const log = {
        timestamp: `${timestamp}`,
        level: `${level}`,
        message: `${message}`,
      };
    
      return JSON.stringify(log);
});

export const logger = createLogger({
    format: combine(timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }), logFormat),
    transports: [new transports.Console()],
});
  
 
export const backgroundLogger = createLogger({
    format: combine(timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }), logFormat),
    transports: [
        new transports.File({ filename: 'errors.log', level: 'warn', handleExceptions: true }),
    ],
});
