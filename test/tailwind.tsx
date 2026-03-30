import { type ComponentProps, forwardRef, useState } from "react";
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

// --- Variants ---------------------------------------------------------------

type ButtonVariant = "primary" | "secondary" | "ghost" | "danger";
type ButtonSize = "sm" | "md" | "lg";

interface ButtonProps extends ComponentProps<"button"> {
  variant?: ButtonVariant;
  size?: ButtonSize;
  loading?: boolean;
  icon?: React.ReactNode;
}

const variantStyles: Record<ButtonVariant, string> = {
  primary:
    "bg-blue-600 text-white shadow-sm hover:bg-blue-700 focus-visible:ring-blue-500 dark:bg-blue-500 dark:hover:bg-blue-400",
  secondary:
    "bg-white text-gray-900 ring-1 ring-inset ring-gray-300 hover:bg-gray-50 dark:bg-gray-800 dark:text-gray-100 dark:ring-gray-600",
  ghost:
    "text-gray-700 hover:bg-gray-100 hover:text-gray-900 dark:text-gray-300 dark:hover:bg-gray-800 dark:hover:text-gray-100",
  danger:
    "bg-red-600 text-white shadow-sm hover:bg-red-500 focus-visible:ring-red-500 dark:bg-red-500 dark:hover:bg-red-400",
};

const sizeStyles: Record<ButtonSize, string> = {
  sm: "px-2.5 py-1.5 text-xs rounded",
  md: "px-3 py-2 text-sm rounded-md",
  lg: "px-4 py-2.5 text-base rounded-lg",
};

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  (
    {
      variant = "primary",
      size = "md",
      loading,
      icon,
      className,
      children,
      disabled,
      ...props
    },
    ref,
  ) => (
    <button
      ref={ref}
      disabled={disabled || loading}
      className={cn(
        "inline-flex items-center justify-center gap-2 font-semibold transition-colors duration-150",
        "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2",
        "disabled:pointer-events-none disabled:opacity-50",
        variantStyles[variant],
        sizeStyles[size],
        className,
      )}
      {...props}
    >
      {loading ? (
        <svg className="h-4 w-4 animate-spin" viewBox="0 0 24 24" fill="none">
          <circle
            className="opacity-25"
            cx="12"
            cy="12"
            r="10"
            stroke="currentColor"
            strokeWidth="4"
          />
          <path
            className="opacity-75"
            fill="currentColor"
            d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z"
          />
        </svg>
      ) : (
        icon
      )}
      {children}
    </button>
  ),
);
Button.displayName = "Button";

// --- Card -------------------------------------------------------------------

interface CardProps {
  title: string;
  description?: string;
  badge?: string;
  image?: string;
  actions?: React.ReactNode;
}

export function Card({ title, description, badge, image, actions }: CardProps) {
  const [isExpanded, setIsExpanded] = useState(false);

  return (
    <article
      className={cn(
        "group relative overflow-hidden rounded-xl border border-gray-200 bg-white",
        "shadow-sm transition-all duration-200 hover:shadow-md",
        "dark:border-gray-700 dark:bg-gray-900",
        isExpanded &&
          "ring-2 ring-blue-500 ring-offset-2 dark:ring-offset-gray-900",
      )}
    >
      {image && (
        <div className="aspect-video w-full overflow-hidden">
          <img
            src={image}
            alt=""
            className="h-full w-full object-cover transition-transform duration-300 group-hover:scale-105"
          />
        </div>
      )}

      <div className="flex flex-col gap-3 p-4 sm:p-6">
        <div className="flex items-start justify-between gap-4">
          <h3 className="text-lg font-semibold leading-tight text-gray-900 dark:text-gray-100">
            {title}
          </h3>
          {badge && (
            <span className="inline-flex shrink-0 items-center rounded-full bg-blue-50 px-2 py-0.5 text-xs font-medium text-blue-700 ring-1 ring-inset ring-blue-600/20 dark:bg-blue-900/30 dark:text-blue-300">
              {badge}
            </span>
          )}
        </div>

        {description && (
          <p
            className={cn(
              "text-sm text-gray-600 dark:text-gray-400",
              !isExpanded && "line-clamp-2",
            )}
          >
            {description}
          </p>
        )}

        <div className="mt-auto flex items-center justify-between pt-2">
          {actions}
          <button
            onClick={() => setIsExpanded(!isExpanded)}
            className="text-xs font-medium text-blue-600 hover:text-blue-800 dark:text-blue-400"
          >
            {isExpanded ? "Show less" : "Read more"}
          </button>
        </div>
      </div>
    </article>
  );
}
